import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_manifest/output_descriptor.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/credential_manifest/ui/get_color_from_credential.dart';
import 'package:talao/credential_manifest/view/display_mapping_widget.dart';
import 'package:talao/credential_manifest/view/display_properties_widget.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/credentials/widget/credential_container.dart';

class OutputDescriptorWidget extends StatelessWidget {
  const OutputDescriptorWidget(this.outputDescriptor, this.item);
  final List<OutputDescriptor> outputDescriptor;
  final CredentialModel item;
  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    outputDescriptor.forEach(((element) {
      var textcolor =
          getColorFromCredential(element.styles?.text, Colors.black);
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CredentialContainer(
          child: CredentialBackground(
            backgroundColor: getColorFromCredential(
                element.styles?.background, Colors.white),
            model: item,
            child: Column(
              children: [
                if (element.styles?.hero != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageFromNetwork(element.styles!.hero!.uri),
                  )
                else
                  SizedBox.shrink(),
                Row(
                  children: [
                    Expanded(
                      child: DisplayMappingWidget(
                        element.display?.title,
                        item,
                        textcolor,
                      ),
                    ),
                    if (element.styles?.thumbnail != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          constraints:
                              BoxConstraints(maxHeight: 100, maxWidth: 100),
                          child:
                              ImageFromNetwork(element.styles!.thumbnail!.uri),
                        ),
                      )
                    else
                      SizedBox.shrink(),
                  ],
                ),
                DisplayMappingWidget(
                  element.display?.subtitle,
                  item,
                  textcolor,
                ),
                DisplayMappingWidget(
                  element.display?.description,
                  item,
                  textcolor,
                ),
                DisplayPropertiesWidget(
                  element.display?.properties,
                  item,
                  textcolor,
                ),
              ],
            ),
          ),
        ),
      ));
    }));
    return Column(
      children: widgets,
    );
  }
}
