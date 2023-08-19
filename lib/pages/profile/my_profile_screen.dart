import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:sociality/Pages/friend/friend_screen.dart';
import 'package:sociality/Pages/profile/edit_profile_screen.dart';
import 'package:sociality/Pages/viewPhoto/image_view.dart';
import 'package:sociality/shared/components/indicator.dart';
import 'package:sociality/model/post_model.dart';
import 'package:sociality/model/user_model.dart';
import 'package:sociality/shared/components/my_divider.dart';
import 'package:sociality/shared/components/navigator.dart';
import 'package:sociality/shared/cubit/socialCubit/social_cubit.dart';
import 'package:sociality/shared/cubit/socialCubit/social_state.dart';
import 'package:sociality/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sociality/shared/widget/build_post_item.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SavedToGalleryLoadingState) {
          Navigator.pop(context);
        }
        if (state is SavedToGallerySuccessState) {
          Fluttertoast.showToast(
              msg: "Downloaded to Gallery!",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 5,
              fontSize: 18);
        }

        if (state is LikesSuccessState) {
          Fluttertoast.showToast(
              msg: "Likes Success!",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 5,
              fontSize: 18);
        }

        if (state is DisLikesSuccessState) {
          Fluttertoast.showToast(
              msg: "UnLikes Success!",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 5,
              fontSize: 18);
        }
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var cubit = SocialCubit.get(context);
        return SocialCubit.get(context).userModel == null
            ? Scaffold(
                body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      IconlyLight.infoSquare,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'No Posts yet',
                      style: GoogleFonts.libreBaskerville(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Colors.grey,
                      ),
                    ),
                    const CircularProgressIndicator(),
                  ],
                ),
              ))
            : cubit.userPosts.isEmpty
                ? SafeArea(
                    child: Scaffold(
                      body: buildProfileWithOutPosts(),
                    ),
                  )
                : ConditionalBuilder(
                    condition: cubit.userPosts.isNotEmpty,
                    builder: (BuildContext context) => SafeArea(
                      child: Scaffold(
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 280,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            ImageViewScreen(
                                                image: cubit.userModel!.cover,
                                                body: ''));
                                      },
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.topCenter,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    userModel!.cover),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                              )),
                                          width: double.infinity,
                                          height: 230,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            ImageViewScreen(
                                                image: cubit.userModel!.image,
                                                body: ''));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 75,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            userModel.image,
                                          ),
                                          radius: 70,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 60,
                                      left: 5,
                                      child: IconButton(
                                        onPressed: () {
                                          pop(context);
                                        },
                                        icon: const CircleAvatar(
                                          backgroundColor: Colors.black,
                                          child: Icon(
                                            IconlyLight.arrowLeft2,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              space(0, 5),
                              Text(
                                userModel.name,
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 20,
                                  color:
                                      cubit.isDark ? Colors.blue : Colors.white,
                                ),
                              ),
                              space(0, 5),
                              Text(
                                userModel.bio,
                                style: GoogleFonts.libreBaskerville(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                              space(0, 15),
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.grey[100],
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${cubit.posts.length}',
                                            style: GoogleFonts.roboto(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 20),
                                            ),
                                          ),
                                          Text(
                                            'Posts',
                                            style: GoogleFonts.libreBaskerville(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '10K',
                                            style: GoogleFonts.libreBaskerville(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 20),
                                            ),
                                          ),
                                          Text(
                                            'Followers',
                                            style: GoogleFonts.libreBaskerville(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          navigateTo(
                                              context,
                                              FriendsScreen(
                                                cubit.friends,
                                                myFriends: true,
                                              ));
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              '${cubit.friends.length}',
                                              style:
                                                  GoogleFonts.libreBaskerville(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(fontSize: 20),
                                              ),
                                            ),
                                            Text(
                                              'Friends',
                                              style:
                                                  GoogleFonts.libreBaskerville(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              space(0, 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton.icon(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue)),
                                        onPressed: () {
                                          cubit.getStoryImage(context);
                                        },
                                        icon: const Icon(
                                          IconlyLight.plus,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Add story',
                                          style: GoogleFonts.libreBaskerville(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    space(20, 0),
                                    Expanded(
                                      child: TextButton.icon(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            cubit.isDark
                                                ? Colors.grey.shade400
                                                : const Color(0xff404258),
                                          ),
                                        ),
                                        onPressed: () {
                                          navigateTo(
                                              context, EditProfileScreen());
                                        },
                                        icon: Icon(
                                          IconlyLight.edit,
                                          color: cubit.isDark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        label: Text(
                                          'Edit profile',
                                          style: GoogleFonts.libreBaskerville(
                                            color: cubit.isDark
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const MyDivider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    'Posts',
                                    style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      color: cubit.isDark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              space(0, 10),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cubit.userPosts.length,
                                separatorBuilder: (context, index) =>
                                    space(0, 10),
                                itemBuilder: (context, index) => (BuildPostItem(
                                  postModel: cubit.posts[index],
                                  userModel: cubit.userModel!,
                                  index: index,
                                )),
                              ),
                              space(0, 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    fallback: (BuildContext context) => Center(
                      child: AdaptiveIndicator(
                        os: getOs(),
                      ),
                    ),
                  );
      },
    );
  }
}

Widget buildProfileWithOutPosts() => Builder(builder: (context) {
      var cubit = SocialCubit.get(context);
      var userModel = SocialCubit.get(context).userModel;
      List<PostModel>? posts = SocialCubit.get(context).userPosts;
      List<UserModel>? friends = SocialCubit.get(context).friends;

      return Column(
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                InkWell(
                  onTap: () {
                    ///view Photo
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => view()));
                  },
                  child: Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userModel!.cover),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          )),
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 65,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userModel.image,
                    ),
                    radius: 60,
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 5,
                  child: IconButton(
                    onPressed: () {
                      pop(context);
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        IconlyLight.arrowLeft2,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          space(0, 5),
          Text(
            userModel.name,
            style: GoogleFonts.roboto(
              fontSize: 24,
              color: cubit.isDark ? Colors.blue : Colors.white,
            ),
          ),
          space(0, 5),
          Text(
            userModel.bio,
            style: GoogleFonts.roboto(
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
            ),
          ),
          space(0, 15),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${posts.length}',
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 20),
                        ),
                      ),
                      Text(
                        'Posts',
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '10K',
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 20),
                        ),
                      ),
                      Text(
                        'Followers',
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          FriendsScreen(
                            friends,
                            myFriends: true,
                          ));
                    },
                    child: Column(
                      children: [
                        Text(
                          '${friends.length}',
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        Text(
                          'Friends',
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          space(0, 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    onPressed: () {
                      cubit.getStoryImage(context);
                    },
                    icon: const Icon(
                      IconlyLight.plus,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add story',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                space(20, 0),
                Expanded(
                  child: TextButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        cubit.isDark
                            ? Colors.grey.shade400
                            : const Color(0xff404258),
                      ),
                    ),
                    onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },
                    icon: Icon(
                      IconlyLight.edit,
                      color: cubit.isDark ? Colors.black : Colors.white,
                    ),
                    label: Text(
                      'Edit profile',
                      style: GoogleFonts.roboto(
                        color: cubit.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const MyDivider(),
          const Spacer(),
          const Icon(
            IconlyLight.infoSquare,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No Posts yet',
            style: GoogleFonts.libreBaskerville(
              fontWeight: FontWeight.w700,
              fontSize: 30,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
        ],
      );
    });
