import 'dart:ui' show ImageFilter;

import '../../../shared/packages.dart';
import '../../../shared/widgets/common_svg_icon.dart';
import '../controllers/dashboard_controller.dart';

class CommonBottomBar extends StatelessWidget {
  const CommonBottomBar({super.key, this.compact = false});

  static const _duration = Duration(milliseconds: 230);
  static const _curve = Curves.easeOutCubic;
  static const _shape = BorderRadius.all(Radius.circular(26));

  final bool compact;

  Animation<Offset> _selectionSlide(DashboardController controller) {
    final start = Offset(controller.selectedIconSlideOffset, 0);
    final overshoot = start * -.2;

    return controller.navAnimationController.drive(
      TweenSequence<Offset>([
        TweenSequenceItem(
          tween: Tween(
            begin: start,
            end: overshoot,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 72,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: overshoot,
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutSine)),
          weight: 28,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final surface = theme.colorScheme.surface;

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return SafeArea(
          top: false,
          child: AnimatedPadding(
            duration: _duration,
            curve: _curve,
            padding: EdgeInsets.fromLTRB(
              compact ? 24 : 14,
              0,
              compact ? 24 : 14,
              8,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: _shape,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? .30 : .12),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: _shape,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: _shape,
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: dark ? .24 : .20,
                          ),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            surface.withValues(alpha: dark ? .80 : .78),
                            surface.withValues(alpha: .92),
                          ],
                        ),
                      ),
                      child: AnimatedPadding(
                        duration: _duration,
                        curve: _curve,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: compact ? 2 : 6,
                        ),
                        child: Row(
                          children: [
                            _navItem(
                              context,
                              controller,
                              AssetPath.homeIcon,
                              'Home',
                              0,
                            ),
                            _navItem(
                              context,
                              controller,
                              AssetPath.attendanceIcon,
                              'Attendance',
                              1,
                            ),
                            _navItem(
                              context,
                              controller,
                              AssetPath.notificationIcon,
                              'Notification',
                              2,
                            ),
                            _navItem(
                              context,
                              controller,
                              AssetPath.personIcon,
                              'Profile',
                              3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(
    BuildContext context,
    DashboardController controller,
    String iconPath,
    String label,
    int index,
  ) {
    final navTheme = Theme.of(context).bottomNavigationBarTheme;
    final selected = controller.selectedIndex == index;
    final color = selected
        ? navTheme.selectedItemColor ?? AppTheme.iconColor(context)
        : navTheme.unselectedItemColor ?? AppColor.kGrayTextColor;

    final icon = CommonSvgIcon(
      asset: iconPath,
      size: compact ? 21 : 24,
      color: color,
    );

    return Expanded(
      child: Semantics(
        selected: selected,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.focused)
                ? Theme.of(context).colorScheme.primary.withValues(alpha: .12)
                : Colors.transparent,
          ),
          onTap: () => controller.changeTab(index),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: _duration,
                  curve: _curve,
                  height: compact ? 29 : 36,
                  alignment: Alignment.center,
                  child: selected
                      ? SlideTransition(
                          position: _selectionSlide(controller),
                          transformHitTests: false,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: .16),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                            child: SizedBox(
                              width: compact ? 44 : 54,
                              height: compact ? 27 : 33,
                              child: Center(child: icon),
                            ),
                          ),
                        )
                      : icon,
                ),
                Text(
                  label,
                  key: ValueKey(selected),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.textStyle(
                    context: context,
                    size: compact ? 9 : 10,
                    weight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
