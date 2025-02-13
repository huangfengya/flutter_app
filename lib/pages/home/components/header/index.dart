import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/sql/index.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  const HomeHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Consumer<DataBaseProvider>(
                  builder: (context, provider, child) => Text(
                    provider.account.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
