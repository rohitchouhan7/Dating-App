import 'package:dating_app/api/fireBalseAPi.dart';
import 'package:dating_app/component/plan%20view%20Widget.dart';
import 'package:dating_app/constants/constants.dart';
import 'package:dating_app/helpers/app_helper.dart';
import 'package:dating_app/helpers/app_localizations.dart';
import 'package:dating_app/models/app_model.dart';
import 'package:dating_app/models/planModel.dart';
import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/widgets/store_products.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VipDialog extends StatefulWidget {
  VipDialog({Key? key}) : super(key: key);

  @override
  State<VipDialog> createState() => _VipDialogState();
}

class _VipDialogState extends State<VipDialog> {
  List plans = [
    {
      "plan": "1_month_950",
      "price":950,
    },
    {
      "plan": "3_month_2700",
      "price":3700,
    },
    {
      "plan": "6_month_5000",
      "price":5000,
    },
    {
      "plan": "1_year_6000",
      "price":6000,
    },
  ];
  @override
  Widget build(BuildContext context) {

    final i18n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      /// User image
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Image.asset('assets/images/crow_badge.png'),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(i18n.translate("vip_account"),
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        //
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage:
                              NetworkImage(UserModel().user.userProfilePhoto),
                        ),
                        //
                        title: Text(
                            '${i18n.translate("hello")} ${UserModel().user.userFullname.split(' ')[0]}, '
                            '${i18n.translate("become_a_vip_member_and_enjoy_the_benefits_below")}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 8)
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                      icon: const Icon(Icons.cancel,
                          color: Colors.white, size: 35),
                      onPressed: () {
                        /// Close Dialog
                        Navigator.of(context).pop();
                      }),
                )
              ],
            ),

            /// VIP Plans
            Container(
              color: Colors.grey.withAlpha(70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(i18n.translate("vip_subscriptions"),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 10, thickness: 1),

                  /// VIP Subscriptions
                  // StoreProducts(
                  //   priceColor: Colors.green,
                  //   icon: Image.asset('assets/images/crow_badge.png',
                  //       width: 50, height: 50),
                  // ),





                  if(UserModel().user.activePlan==null)...{
                    FutureBuilder(
                        future: DataBase().getPlans(),
                        builder: (context,s){
                          if(s.connectionState==ConnectionState.waiting)
                          {
                            return const  Center(child: CircularProgressIndicator(),);
                          }
                          if(s.hasError)
                          {
                            return  Center(child: Text("${s.error}"),);
                          }
                          if(s.data==null||s.data?.docs.length==0)
                          {
                            return const Center(child: Text("No Plans avlabl"),);
                          }


                          return Column(
                            children: s.data?.docs.map((e){
                              var _p = VipPlanDetail.fromJson(e.data());

                              return PlanViewTile(
                                plan: _p,
                              );

                              //
                            }).toList()??[],
                          );
                        }),

                  }
                  else...{
                   FutureBuilder(
                     future: DataBase().getVipPlan(UserModel().user.activePlan?.planId??""),
                     builder: (c,s){
                       var _loding = s.connectionState==ConnectionState.waiting;

                       if(_loding)
                         {
                           return const Center(child: CircularProgressIndicator(),);
                         }
                       if(s.data==null)
                         {
                           return Text("null");
                         }

                       return  PlanViewTile(active: true,plan:s.data!,);
                     },
                   )
                  },


                  // const Divider(thickness: 1, height: 30),

                  // Show Restore VIP Subscription button
                  // Center(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //           i18n.translate(
                  //               'have_you_already_purchased_a_VIP_account'),
                  //           style: const TextStyle(fontSize: 16),
                  //           textAlign: TextAlign.center),
                  //       const SizedBox(height: 10),
                  //       // Restore subscription button
                  //       TextButton.icon(
                  //         icon: const Icon(Icons.refresh),
                  //         style: ButtonStyle(
                  //             backgroundColor: MaterialStateProperty.all<Color>(
                  //                 Colors.white),
                  //             shape: MaterialStateProperty.all<OutlinedBorder>(
                  //                 RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(28),
                  //             ))),
                  //         label: Text(i18n.translate('restore_subscription')),
                  //         onPressed: () async {
                  //           // Show toast processing message
                  //           Fluttertoast.showToast(
                  //             msg: i18n.translate('processing'),
                  //             gravity: ToastGravity.CENTER,
                  //             backgroundColor: APP_PRIMARY_COLOR,
                  //             textColor: Colors.white,
                  //           );
                  //           // Restore VIP subscription
                  //           AppHelper().restoreVipAccount(showMsg: true);
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const Divider(thickness: 1),
                ],
              ),
            ),
            const Divider(),

            /// VIP Benefits
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(i18n.translate("benefits"),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 10, thickness: 1),

                  // Passport
                  ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.flight, color: Colors.white),
                    ),
                    title: Text(i18n.translate("passport"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(i18n.translate(
                        "travel_to_any_country_or_city_and_match_with_people_there")),
                  ),
                  const Divider(height: 10, thickness: 1),

                  // Discover more people around you
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.purple,
                      child:
                          Icon(Icons.location_on_outlined, color: Colors.white),
                    ),
                    title: Text(i18n.translate("discover_more_people"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text("${i18n.translate('get')} "
                        "${AppModel().appInfo.vipAccountMaxDistance} km "
                        "${i18n.translate('radius_away')}"),
                  ),
                  const Divider(height: 10, thickness: 1),

                  // Add more pictures
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                    title: Text(
                        i18n.translate(
                            "add_more_pictures_on_your_profile_gallery"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(i18n.translate(
                        "make_your_profile_attractive_by_adding_more_photos")),
                  ),
                  const Divider(height: 10, thickness: 1),

                  /// See who liked you
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                    title: Text(i18n.translate("see_people_who_liked_you"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(i18n.translate(
                        "unravel_the_mystery_and_find_out_who_liked_you")),
                  ),
                  const Divider(height: 10, thickness: 1),

                  /// See who visited you
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.remove_red_eye, color: Colors.white),
                    ),
                    title: Text(
                        i18n.translate("see_people_who_visited_your_profile"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(i18n.translate(
                        "unravel_the_mystery_and_find_out_who_visited_your_profile")),
                  ),
                  const Divider(height: 10, thickness: 1),

                  /// See disliked profiles
                  ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    title: Text(i18n.translate("see_people_you_have_rejected"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(
                        i18n.translate("retrieve_and_review_all_profiles")),
                  ),
                  const Divider(height: 10, thickness: 1),

                  /// Verified account badge
                  ListTile(
                    leading: Image.asset('assets/images/verified_badge.png',
                        width: 40, height: 40),
                    title: Text(i18n.translate("verified_account_badge"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(i18n.translate(
                        "let_other_users_know_that_you_are_a_real_person")),
                  ),
                  const Divider(height: 10, thickness: 1),

                  /// No Ads
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.block, color: Colors.white),
                    ),
                    title: Text(i18n.translate("no_ads"),
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(i18n.translate("have_a_unique_experience")),
                  ),
                  const Divider(height: 10, thickness: 1),
                  const SizedBox(height: 15)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
