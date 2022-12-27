import 'package:daily_report/components/constant/contant.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(accountName: Text("Talha Iqbal",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: width * 0.06),), accountEmail:Text("03012070920",style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("T",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.09,color: appMainColor),),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Shops '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Add Employee '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' Create Shop '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Search Report '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: width * 0.04,horizontal: width * 0.04),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all( width: 2,color: Colors.grey.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(7)
              ),
              child: ListTile(
                leading: Icon(Icons.add,color: Colors.grey,),
                title: Text("Create New Report"),
              ),
            ),
            SizedBox(height: width * 0.04,),

          ],
        ),
      ),
    );
  }
}
