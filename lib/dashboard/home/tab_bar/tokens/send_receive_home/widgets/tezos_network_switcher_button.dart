import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/manage_network/cubit/manage_network_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TezosNetworkSwitcherButton extends StatelessWidget {
  const TezosNetworkSwitcherButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.activeColorOfNetwork,
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.space2XSmall),
            child: BlocBuilder<ManageNetworkCubit, ManageNetworkState>(
                builder: (context, state) {
              return Text(
                state.network.description,
                style: Theme.of(context).textTheme.caption?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
              );
            }),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: Sizes.icon,
            color: Theme.of(context).colorScheme.inversePrimary,
          )
        ],
      ),
    );
  }
}
