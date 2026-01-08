import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music/generated/assets.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.miniPlayer,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final Widget miniPlayer;
  final int selectedIndex;
  final Function(int index) onTabSelected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final items = [
      NavigationItem(
        title: 'Home',
        icon: SvgPicture.asset(Assets.svgHome, height: 24, width: 24),
      ),
      NavigationItem(
        title: 'Albums',
        icon: SvgPicture.asset(Assets.svgAlbums, height: 24, width: 24),
      ),
      NavigationItem(
        title: 'Tracks',
        icon: SvgPicture.asset(Assets.svgTracks, height: 24, width: 24),
      ),
      NavigationItem(
        title: 'Playlist',
        icon: SvgPicture.asset(Assets.svgPlaylist, height: 24, width: 24),
      ),
      NavigationItem(
        title: 'Settings',
        icon: SvgPicture.asset(Assets.svgSettings, height: 24, width: 24),
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  miniPlayer,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 8,
                      children: items.map((item) {
                        final index = items.indexOf(item);
                        final isSelected = index == selectedIndex;
                        return GestureDetector(
                          onTap: () => onTabSelected(index),
                          child: Container(
                            width: size.width / (isSelected ? 3.3 : 8.4),
                            height: size.width / 8,
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSelected ? 6 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0XFF1ED760)
                                  : Colors.white.withValues(alpha: 0.2),
                              shape: isSelected
                                  ? BoxShape.rectangle
                                  : BoxShape.circle,
                              borderRadius: isSelected
                                  ? BorderRadius.circular(24)
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: .center,
                              spacing: 6,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    isSelected ? Colors.black : Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                  child: item.icon,
                                ),
                                if (isSelected)
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  String title;
  Widget icon;

  NavigationItem({required this.title, required this.icon});
}
