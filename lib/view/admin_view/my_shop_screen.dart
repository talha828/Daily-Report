import 'package:daily_report/generated/assets.dart';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/main.dart';
import 'package:daily_report/model/shop_model.dart';
import 'package:daily_report/view/admin_view/create_shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/constant/contant.dart';


class MyShopScreen extends StatefulWidget {
  const MyShopScreen({Key? key}) : super(key: key);

  @override
  State<MyShopScreen> createState() => _MyShopScreenState();
}

class _MyShopScreenState extends State<MyShopScreen> {
  final userData = Get.find<UserModel>();
  List<ShopModel> shops = [];
  getShop() async {
    shops.clear();
    var data = await altogic.db
        .model('users.shop')
        .filter('username == "${userData.username.value}"')
        .get();
    for (var i in data.data) {
      shops.add(ShopModel(
          ownerName: i['ownerName'],
          userName: i['username'],
          shopName: i['shopName'],
          address: i['address'],
          id: i['_id']));
    }
    setState(() {});
  }

  @override
  void initState() {
    getShop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text("My Shop"),
        actions: [
          InkWell(
            onTap: () => getShop(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          ),
          InkWell(
            onTap: () => Get.to(CreateShopScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(
            vertical: width * 0.04, horizontal: width * 0.04),
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        radius: width * 0.06,
                        backgroundColor: appMainColor,
                        child: Image.asset(Assets.iconShop,
                            width: width * 0.06, height: width * 0.06)),
                    title: Text(shops[index].shopName!),
                    subtitle: Text(shops[index].address!),
                    trailing: InkWell(
                        onTap: () async {
                          var result = await altogic.db
                              .model('users.shop')
                              .object(shops[index].id)
                              .delete()
                              .then((value) => getShop());
                        },
                        child: Icon(Icons.delete)),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: width * 0.04);
                },
                itemCount: shops.length)
          ],
        ),
      ),
    );
  }
}
