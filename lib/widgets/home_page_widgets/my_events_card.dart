import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/main_screens/event_screen.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/utilities/utils.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:shimmer/shimmer.dart';

class MyEventsCard extends StatelessWidget {
  const MyEventsCard({
    super.key,
    required this.height,
    required this.width,
    required this.event,
    required this.appConfig,
    required this.onPop,
    this.functionCaller,
    required this.isLoading,
  });

  final double height;
  final double width;
  final EventModel? event;
  final AppConfig appConfig;
  final void Function(bool) onPop;
  final FirebaseFunctionCaller? functionCaller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
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
        if (event == null) {
          return;
        }
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Material(
              child: EventScreen(
                event: event!,
                functionCaller: functionCaller,
              ),
            ),
          ),
        );

        if (result is bool && result == true) {
          onPop(true);
          return;
        }

        onPop(false);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
          /*border: getCustomBorder(
            appConfig: appConfig,
            width: 0.5,
          ),*/
        ),
        child: Row(
          children: [
            Container(
              height: appConfig.isTablet() ? 180 : width * 0.2,
              width: appConfig.isTablet() ? 180 : width * 0.2,
              decoration: BoxDecoration(
                color: appConfig.getTheme().scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: event == null
                    ? SizedBox()
                    : event!.image == null || event!.image!.downloadUrl == null
                        ? Image.asset(
                            'assets/images/party.png',
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: event!.image!.downloadUrl!,
                            fit: BoxFit.cover,
                            memCacheWidth: 600,
                            memCacheHeight: 600,
                            placeholder: (context, url) => ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              ),
                              child: Image.asset(
                                'assets/images/party.png',
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: appConfig.isTablet() ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.007),
                    child: event == null
                        ? Container(
                            width: 200,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color:
                                  appConfig.getTheme().scaffoldBackgroundColor,
                            ),
                          )
                        : Text(event == null ? '' : event!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyleEventCardTitle(context)),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(right: width * 0.02),
                          child: Icon(
                            size: appConfig.isTablet() ? 20 : 14,
                            Icons.place_outlined,
                          ),
                        ),
                      ),
                      event == null
                            ? Container(
                          width: 150,
                          height: 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color:
                            appConfig.getTheme().scaffoldBackgroundColor,
                          ),
                        )
                            : Expanded(
                        child:  Text(
                          event == null ? '' : event!.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyleEventCardSubtitle(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: event == null ? 10 : 3,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(right: width * 0.02),
                          child: Icon(
                            size: appConfig.isTablet() ? 20 : 14,
                            Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                      event == null
                          ? Container(
                        width: 120,
                        height: 13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color:
                          appConfig.getTheme().scaffoldBackgroundColor,
                        ),
                      )
                          : Expanded(
                        child: Text(
                          event == null
                              ? ''
                              : formatDateToDayMonth(event!.start),
                          style: textStyleEventCardSubtitle(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
