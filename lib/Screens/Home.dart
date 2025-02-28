import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:test_ali/Screens/About.dart';
import 'package:test_ali/Screens/Scaning.dart';
import 'package:test_ali/Screens/StartedScreen.dart';
import 'package:test_ali/Screens/chat%20list%20screen.dart';
import 'package:test_ali/Screens/pyramids.dart';

import '../MODELS/Postlmodel.dart';
import '../main.dart';
import 'Login.dart';
import 'Setting.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  var _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<PostsModel> postsModel = [];
  List<PostsModel> allModel = [];

  @override
  void initState() {
    super.initState();
    getPlaces();
  }

  getPlaces() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('places').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          // استخدم map للتحقق من وجود الحقول المطلوبة
          Map<String, dynamic> data = querySnapshot.docs[i].data() as Map<String, dynamic>;
          String country = data.containsKey('country') ? data['country'] : 'Unknown';
          String image = data.containsKey('image') ? data['image'] : '';
          String title = data.containsKey('title') ? data['title'] : '';
          String description = data.containsKey('description') ? data['description'] : '';

          QuerySnapshot querySnapshotFav = await FirebaseFirestore.instance
              .collection('fav')
              .where('user_id', isEqualTo: sharedpref!.getString('uid'))
              .where('post_id', isEqualTo: querySnapshot.docs[i].id)
              .get();
          bool isFav = querySnapshotFav.size > 0;

          PostsModel post = PostsModel(
              id: querySnapshot.docs[i].id,
              name: country,
              imgPath: image,
              title: title,
              isFav: isFav,
              description: description,
              isPlaces: true);
          postsModel.add(post);
          allModel.add(post);

          print('data: $country');
        }
        setState(() {});

        QuerySnapshot querySnapshotStatues =
        await _firestore.collection('statues').get();

        if (querySnapshotStatues.docs.isNotEmpty) {
          for (int x = 0; x < querySnapshotStatues.docs.length; x++) {
            Map<String, dynamic> statueData =
            querySnapshotStatues.docs[x].data() as Map<String, dynamic>;
            allModel.add(PostsModel(
                id: querySnapshotStatues.docs[x].id,
                name: '',
                imgPath: statueData.containsKey('image') ? statueData['image'] : '',
                title: statueData.containsKey('title') ? statueData['title'] : '',
                isFav: false,
                description: statueData.containsKey('description')
                    ? statueData['description']
                    : '',
                isPlaces: false));
          }
        }
      }
    } catch (e) {
      print('error_' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.brown[800]),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Container(
          width: 220,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            textAlign: TextAlign.start,
            onChanged: (val) async {
              postsModel.clear();
              if (val.isEmpty) {
                getPlaces();
              } else {
                postsModel.addAll(allModel.where((searchItem) =>
                    searchItem.title!
                        .toLowerCase()
                        .contains(val.toLowerCase())));
              }
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.brown.shade900),
              suffixIcon: Icon(Icons.search, color: Colors.brown.shade900),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding:
              EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.brown[800], fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName:
              Text("User Name", style: TextStyle(color: Colors.white)),
              accountEmail:
              Text("user@example.com", style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
              decoration: BoxDecoration(color: Colors.brown[800]),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.brown[800]),
              title: Text("Home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>HomePage()),
                );

              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.brown[800]),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>SettingsPage()),
                );

              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.brown[800]),
              title: Text("Ask"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>ChatListScreen()),
                );

              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.brown[800]),
              title: Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>AboutPage()),
                );

              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.brown[800]),
              title: Text("Logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>Startedscreen()),
                );

              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome To Tour Scan",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800]),
              ),
              SizedBox(height: 5),
              Text(
                "Find your Next Adventure",
                style:
                TextStyle(fontSize: 16, color: Colors.brown.shade600),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  // الصورة مع زوايا دائرية
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25), // زوايا دائرية قوية
                    child: SizedBox(
                      width: 538,
                      height: 227,
                      child: Image.network(
                        'https://s3-alpha-sig.figma.com/img/abb0/552e/16a04dd4bd365e859919801c65f396ab?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=LLImvDU6t8RJh0VnA0EVelfLxNMq0t71sqpByoA-uThtFUgxOXWrrG0sxEorXQ4rcmilPdu~blLjDulrhhsnASzooA~~S5SXioipRpZpe-eqVfCpykQlf9cMeMoyORZdSZ3CK1jL8UEf4gPkmd98NCjZE90LPbfujGPAT~8fauD2hewnBN1p5Lynr4JINsEFMvFJaNH58m4V81GtBfWOOXze5RN6e0~r87NCIYeJ-851EmvQ1F2eRMeP0vyaAHioL-7SaJ0BXcbtPnpcNZMYzTQ1gVUPLH4RxfHe~X~BjWIL5UaVNhf11ZmfjJnOMWF0dabnhNTk~8qdOLDlwVh3rQ__',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // النصوص داخل مستطيل شفاف
                  Positioned(
                    bottom: 10, // وضع النصوص قرب أسفل الصورة
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black26, // تفتيح الخلفية أكثر لجعلها ناعمة
                        borderRadius: BorderRadius.circular(12), // زوايا ناعمة
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // المحاذاة لليسار
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Egyptian Museum',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white, // العنوان بالأبيض
                            ),
                          ),
                          Text(
                            'Egypt, Giza',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[300], // لون أفتح قليلاً
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // بقية الكود الخاص بعرض الـ Category و Explore...
              Text(
                "Category",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800]),
              ),
              Container(
                width: 300,
                height: 196,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postsModel.length,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('history')
                              .doc()
                              .set({
                            'post_id': postsModel[index].id!,
                            'user_id': sharedpref!.getString('uid'),
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Pyramids(postsModel: postsModel[index]),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FillImageCard(
                            width: 200,
                            heightImage: 100,
                            color: Colors.grey.shade300,
                            imageProvider:
                            NetworkImage(postsModel[index].imgPath!),
                            description: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      postsModel[index].name!,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context)
                                          .width *
                                          .22,
                                      child: Text(
                                        postsModel[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              Text(
                "Explore",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800]),
              ),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: postsModel.length,
                  padding: EdgeInsets.symmetric(vertical: 9),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('history')
                            .doc()
                            .set({
                          'post_id': postsModel[index].id!,
                          'user_id': sharedpref!.getString('uid'),
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Pyramids(postsModel: postsModel[index]),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    postsModel[index].imgPath!,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        postsModel[index].name!,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        postsModel[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios,
                                      color: Colors.black54),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('history')
                                        .doc()
                                        .set({
                                      'post_id': postsModel[index].id!,
                                      'user_id': sharedpref!.getString('uid'),
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Pyramids(
                                                postsModel:
                                                postsModel[index]),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey.shade400),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => /*ScanningPage()*/  AboutPage() ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[800],
              fixedSize: Size(60, 60),
              padding: EdgeInsets.zero, // إزالة الـ padding الافتراضي
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.qr_code_scanner_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }
}

