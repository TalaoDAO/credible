import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TokenItem extends StatelessWidget {
  const TokenItem({
    Key? key,
    required this.logoPath,
    required this.symbol,
    required this.name,
    required this.balance,
  }) : super(key: key);

  final String logoPath;
  final String symbol;
  final String name;
  final int balance;

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat('#,###,000');
    return BackgroundCard(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: Image.asset(
            logoPath,
            width: Sizes.tokenLogoSize,
          ),
        ),
        title: Text(
          name.toUpperCase(),
          style: Theme.of(context).textTheme.listTileTitle,
        ),
        subtitle: Text(
          symbol,
          style: Theme.of(context).textTheme.listTileSubtitle,
        ),
        trailing: Text(
          numberFormatter.format(balance),
          style:
              Theme.of(context).textTheme.listTileTitle.copyWith(fontSize: 13),
        ),
      ),
    );
  }
}
