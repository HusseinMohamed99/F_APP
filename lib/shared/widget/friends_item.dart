import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sociality/model/user_model.dart';
import 'package:sociality/pages/chat/private_chat.dart';
import 'package:sociality/pages/friend/friends_profile_screen.dart';
import 'package:sociality/shared/components/image_with_shimmer.dart';
import 'package:sociality/shared/components/navigator.dart';
import 'package:sociality/shared/cubit/socialCubit/social_cubit.dart';
import 'package:sociality/shared/styles/color.dart';

class FriendsBuildItems extends StatelessWidget {
  const FriendsBuildItems({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).build(context);
        navigateTo(context, FriendsProfileScreen(userModel.uId));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            child: ImageWithShimmer(
              imageUrl: userModel.image,
              radius: 25.r,
              width: 50.w,
              height: 50.h,
              boxFit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              userModel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8).r,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SocialCubit.get(context).isDark
                    ? AppMainColors.blueColor
                    : AppMainColors.whiteColor,
              ),
              onPressed: () =>
                  navigateTo(context, PrivateChatScreen(userModel: userModel)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconlyBroken.chat,
                    size: 24.sp,
                    color: SocialCubit.get(context).isDark
                        ? AppMainColors.whiteColor
                        : AppMainColors.blackColor,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Message',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}