import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:images/controller/home_page_controller.dart';
import 'package:images/view/detail_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              _myAppBar(size, context),
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTabBar(size),
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Expanded(
                      flex: 13,
                      child: Obx(
                        () => controller.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget.flickr(
                                  rightDotColor: Colors.black,
                                  leftDotColor: const Color(0xfffd0079),
                                  size: 30,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GridView.custom(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: SliverQuiltedGridDelegate(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    //      repeatPattern: QuiltedGridRepeatPattern.inverted,
                                    pattern: const [
                                      QuiltedGridTile(2, 2),
                                      QuiltedGridTile(1, 1),
                                      QuiltedGridTile(1, 1),
                                      QuiltedGridTile(1, 2),
                                    ],
                                  ),
                                  childrenDelegate: SliverChildBuilderDelegate(
                                    childCount: controller.photos.length,
                                    (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  DetailView(index: index),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: controller.photos[index].id!,
                                          child: Container(
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                  .photos[index].urls!['small'],
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: LoadingAnimationWidget
                                                    .flickr(
                                                  rightDotColor: Colors.black,
                                                  leftDotColor:
                                                      const Color(0xfffd0079),
                                                  size: 25,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(Size size) {
    return ListView.builder(
        itemCount: controller.orders.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                controller.selectedIndex.value = index;
                controller.orderFunc(controller.orders[index]);
              },
              child: AnimatedContainer(
                margin: EdgeInsets.fromLTRB(
                    index == 0 ? size.width * 0.02 : size.width * 0.05,
                    0,
                    5,
                    0),
                width: size.width * 0.3,
                duration: Duration(
                  milliseconds: 250,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      index == controller.selectedIndex.value ? 18 : 15,
                    ),
                  ),
                  color: controller.selectedIndex.value == index
                      ? Colors.grey[700]
                      : Colors.grey[200],
                ),
                child: Center(
                    child: Text(
                  controller.orders[index],
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: index == controller.selectedIndex.value
                        ? Colors.white
                        : Colors.black,
                  ),
                )),
              ),
            ),
          );
        });
  }

  Widget _myAppBar(Size size, BuildContext context) {
    return Container(
      width: size.width,
      height: size.height * 0.35,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/1.jpg'), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What would you like\n to Find?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            //padding: EdgeInsets.only(left: 15),
            width: size.width * 0.9,
            height: size.height * 0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200]),
            child: const TextField(
              readOnly: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 23,
                    color: Colors.grey,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
