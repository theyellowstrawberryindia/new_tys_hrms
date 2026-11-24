import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' show GetxController;
import 'package:intl/intl.dart';

typedef ProfileRecordDraft = ({
  TextEditingController key,
  Map<String, String> fields,
  Map<String, dynamic>? original,
});

typedef ProfileFieldRule = ({String label, int min, int max});

mixin ProfileRecordsSave on GetxController {
  final _savedRows = <TextEditingController>{};
  final _fieldErrors = <TextEditingController, Map<String, String>>{};
  bool isSavingRecords = false;
  bool recordSaveSucceeded = false;
  String? recordSaveMessage;

  List<ProfileRecordDraft> get recordDrafts;
  Map<String, ProfileFieldRule> get recordFieldRules;
  bool get hasSavedRows => _savedRows.isNotEmpty;

  bool recordIsLocked(TextEditingController key) => _savedRows.contains(key);

  String? recordFieldError(TextEditingController key, String field) =>
      _fieldErrors[key]?[field];

  void resetRecordSaveFeedback() {
    _savedRows.clear();
    _fieldErrors.clear();
    recordSaveMessage = null;
    recordSaveSucceeded = false;
  }

  void removeRecordErrors(TextEditingController key) {
    _fieldErrors.remove(key);
  }

  Future<void> discardRecordChanges({
    required Future<void> Function() refresh,
    required VoidCallback finish,
  }) async {
    if (isSavingRecords) return;
    if (!hasSavedRows) {
      resetRecordSaveFeedback();
      finish();
      update();
      return;
    }

    isSavingRecords = true;
    update();
    var refreshed = false;
    try {
      await refresh();
      refreshed = true;
    } catch (_) {
      // Confirmed writes stay on the server even if the local list is stale.
    } finally {
      resetRecordSaveFeedback();
      finish();
      if (!refreshed) {
        recordSaveMessage =
            'Unsaved edits were discarded. Earlier changes were saved, but the list could not refresh.';
      }
      isSavingRecords = false;
      update();
    }
  }

  bool validateRecordDrafts() {
    _fieldErrors.clear();
    recordSaveMessage = null;
    recordSaveSucceeded = false;
    final drafts = recordDrafts;
    for (final (index, draft) in drafts.indexed) {
      if (recordIsLocked(draft.key) || !_hasChanges(draft)) continue;
      final errors = <String, String>{};
      for (final entry in recordFieldRules.entries) {
        final field = entry.value;
        final length = draft.fields[entry.key]!.length;
        if (length == 0) {
          errors[entry.key] = 'Enter the ${field.label}.';
        } else if (length < field.min || length > field.max) {
          errors[entry.key] =
              '${field.label} must be ${field.min}–${field.max} characters.';
        }
      }
      final start = _parseDate(draft.fields['start_date']!);
      final end = _parseDate(draft.fields['end_date']!);
      if (start == null) errors['start_date'] = 'Choose a valid start date.';
      if (end == null) {
        errors['end_date'] = 'Choose a valid end date.';
      } else if (start != null && end.isBefore(start)) {
        errors['end_date'] = 'End date must be on or after the start date.';
      }
      if (errors.isNotEmpty) {
        _fieldErrors[draft.key] = errors;
        recordSaveMessage ??= 'Entry ${index + 1}: ${errors.values.first}';
      }
    }
    update();
    return _fieldErrors.isEmpty;
  }

  Future<void> saveRecordChanges({
    required int? userId,
    required Future<dynamic> Function(Map<String, dynamic>) add,
    required Future<dynamic> Function(Map<String, dynamic>) edit,
    required Future<void> Function() refresh,
    required VoidCallback finish,
    required String successMessage,
  }) async {
    if (isSavingRecords || !validateRecordDrafts()) return;
    if (userId == null || userId <= 0) {
      recordSaveMessage =
          'Employee details are unavailable. Reopen your profile and try again.';
      update();
      return;
    }

    final drafts = recordDrafts;
    isSavingRecords = true;
    update();
    try {
      for (final (index, draft) in drafts.indexed) {
        if (recordIsLocked(draft.key) || !_hasChanges(draft)) continue;
        final original = draft.original;
        final body = {
          ..._apiFields(draft.fields),
          'userid': '$userId',
          if (original != null) 'id': original['id'],
        };
        try {
          final response = await (original == null ? add(body) : edit(body));
          if (response is! Map || response['success'] != true) {
            _recordFailure(index, draft, response);
            return;
          }
        } on DioException catch (error) {
          final status = error.response?.statusCode ?? 0;
          if (status == 401 || status == 403) {
            _recordFailure(
              index,
              draft,
              null,
              'Your session cannot save this entry. Sign in again or contact HR.',
            );
          } else if (status >= 400 && status < 500) {
            _recordFailure(index, draft, error.response?.data);
          } else if (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout) {
            _recordFailure(
              index,
              draft,
              null,
              'Check your internet connection and try again.',
            );
          } else if (error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            _recordFailure(
              index,
              draft,
              null,
              'The request timed out. Check whether this entry was saved before retrying.',
            );
          } else {
            _recordFailure(index, draft, null);
          }
          return;
        } catch (_) {
          _recordFailure(index, draft, null);
          return;
        }
        _savedRows.add(draft.key);
      }

      if (hasSavedRows) {
        try {
          await refresh();
        } catch (_) {
          recordSaveMessage =
              'Changes were saved, but the list could not refresh. Tap Save again to refresh it.';
          return;
        }
      }
      resetRecordSaveFeedback();
      finish();
      recordSaveSucceeded = true;
      recordSaveMessage = successMessage;
    } finally {
      isSavingRecords = false;
      update();
    }
  }

  void _recordFailure(
    int index,
    ProfileRecordDraft draft,
    Object? response, [
    String? fallback,
  ]) {
    final errors = response is Map ? response['errors'] : null;
    final fieldErrors = <String, String>{};
    if (errors is Map) {
      for (final field in draft.fields.keys) {
        final value = errors[field];
        final message = value is List ? value.firstOrNull : value;
        if (message is String && message.trim().isNotEmpty) {
          fieldErrors[field] = message.trim();
        }
      }
    }
    if (fieldErrors.isNotEmpty) _fieldErrors[draft.key] = fieldErrors;
    final message = response is Map
        ? response['message'] ?? response['error'] ?? response['errormsg']
        : null;
    final detail =
        fieldErrors.values.firstOrNull ??
        (message is String && message.trim().isNotEmpty
            ? message.trim()
            : fallback) ??
        'Couldn’t save this entry. Try again.';
    final previous = hasSavedRows ? 'Earlier changes were saved. ' : '';
    recordSaveMessage = '${previous}Entry ${index + 1}: $detail';
  }

  bool _hasChanges(ProfileRecordDraft draft) {
    final original = draft.original;
    return original == null ||
        _apiFields(draft.fields).entries.any(
          (entry) => entry.value != original[entry.key]?.toString().trim(),
        );
  }

  DateTime? _parseDate(String value) =>
      DateFormat('dd MMM yyyy').tryParseStrict(value);

  Map<String, String> _apiFields(Map<String, String> fields) => {
    ...fields,
    for (final key in ['start_date', 'end_date'])
      if (_parseDate(fields[key]!) case final date?)
        key: DateFormat('yyyy-MM-dd').format(date),
  };
}
