import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/cloud_firestore.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
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
                                        Text(
                                          "${documents[i]['vote']}",
                                          style: const TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // (documents[i]['status'] == true)
                                    //     ? const Icon(
                                    //   Icons.where_to_vote,
                                    //   color: Colors.green,
                                    //   size: 40,
                                    // )
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
