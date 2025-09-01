import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/main_screens/event_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/utilities/utils.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:shimmer/shimmer.dart';

class MyConsigliatiCard extends StatelessWidget {
  const MyConsigliatiCard({
    super.key,
    required this.height,
    required this.width,
    required this.event,
    required this.appConfig,
    required this.onPop,
    required this.isLoading,
  });

  final double height;
  final double width;
  final EventModel? event;
  final AppConfig appConfig;
  final void Function(bool) onPop;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig(context);

    if (isLoading) {
      return Shimmer.fromColors(
          baseColor: shimmerColorBase,
          highlightColor: shimmerColorHighlight,
          child: buildWidget(context));
    }

    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (event == null) return;
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(event: event!),
          ),
        );

        if (result is bool && result == true) {
          onPop(true);
          return;
        }

        onPop(false);
      },
      child: Container(
        constraints:
            BoxConstraints(maxHeight: height * 0.4, maxWidth: width * 0.7),
        padding: EdgeInsets.only(right: 15),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
          ),
          child: Stack(children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                child: event == null
                    ? SizedBox()
                    : event!.image == null || event!.image!.downloadUrl == null
                        ? Image.asset(
                            'assets/images/party.png',
                            fit: BoxFit.cover,
                          )
                        : Hero(
                            tag: 'event-image-${event!.id}',
                            child: CachedNetworkImage(
                              imageUrl: event!.image!.downloadUrl!,
                              fit: BoxFit.cover,
                              memCacheWidth: 600,
                              memCacheHeight: 400,
                              placeholder: (context, url) => ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.saturation,
                                ),
                                child: Image.asset(
                                  'assets/images/ballo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/party.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
              ),
            ),
            Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                  constraints: BoxConstraints(maxWidth: width * 0.5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.01)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event == null ? '' : event!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyleEventCardTitle(context),
                        ),
                        Text(
                          event == null
                              ? ''
                              : formatDateToDayMonth(event!.start),
                          style: textStyleEventCardSubtitle(context),
                        ),
                      ]),
                )),
          ]),
        ),
      ),
    );
  }
}
