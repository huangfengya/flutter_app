import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  const HomeHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  "可能南方",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              )
            ],
          ),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined),
            ],
          )
        ],
      ),
    );
  }
}
