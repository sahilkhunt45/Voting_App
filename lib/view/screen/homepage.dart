// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/global.dart';
import '../../helper/cloud_firestore.dart';
import '../../helper/firebase_auth_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voting App"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: const Icon(Icons.where_to_vote),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('result_page');
            },
            icon: const Icon(
              Icons.leaderboard,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: CloudFirestoreHelper.cloudFirestoreHelper.selectPartyRecord(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: SelectableText("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot? data = snapshot.data;
              List<QueryDocumentSnapshot> documents = data!.docs;
              return (documents.isNotEmpty)
                  ? ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, i) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  if (Global.user!['vote'] == false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Are You Sure To Vote ${documents[i]['pname']} Party?"),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.purple,
                                              ),
                                              onPressed: () async {
                                                int vote = documents[i]['vote'];
                                                vote++;
                                                Map<String, dynamic>
                                                    voteNumber = {
                                                  'vote': vote,
                                                };
                                                await CloudFirestoreHelper
                                                    .cloudFirestoreHelper
                                                    .updateVoteNumber(
                                                  voteNumber: voteNumber,
                                                  id: documents[i].id,
                                                );

                                                Map<String, dynamic>
                                                    updatedData = {
                                                  'vote': true,
                                                };
                                                await CloudFirestoreHelper
                                                    .cloudFirestoreHelper
                                                    .updateVote(
                                                        voteData: updatedData,
                                                        email: Global
                                                            .user!['email']);
                                                Global.user!['vote'] = true;
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        'vote_page');
                                              },
                                              child: const Text("Yes"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("You have already voted"),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.purple, width: 4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "${documents[i]['image']}")),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${documents[i]['pname']}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            "${documents[i]['cname']}",
                                            style: const TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Text(
                                      //   "${documents[i]['vote']}",
                                      //   style: const TextStyle(
                                      //     color: Colors.purple,
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 30,
                                      //   ),
                                      // ),
                                      // (Global.user!['vote'] == true)
                                      //     ? const Icon(
                                      //         Icons.where_to_vote,
                                      //         color: Colors.green,
                                      //         size: 40,
                                      //       )
                                      //     : Container(),
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "${documents[i]['cimage']}"),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Container();
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.purple),
              );
            }
          }),
    );
  }
}
