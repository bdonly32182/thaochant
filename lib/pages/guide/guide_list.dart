import 'package:chanthaburi_app/pages/guide/create_guide.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/bad_request_error.dart';
import 'package:chanthaburi_app/widgets/fetch/search_result_found.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GuideList extends StatefulWidget {
  GuideList({Key? key}) : super(key: key);

  @override
  State<GuideList> createState() => _GuideListState();
}

class _GuideListState extends State<GuideList> {
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  final int _pageSize = 10;
  final PagingController<int, QueryDocumentSnapshot<Object?>>
      _pagingController = PagingController(firstPageKey: 0);
  QueryDocumentSnapshot? lastDocument;

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) => loadMoreBuyers(pageKey),
    );
    super.initState();
  }

  void onSearch(bool isStatusShow) {
    setState(() {
      isSearch = isStatusShow;
    });
  }

  Future<void> loadMoreBuyers(int pageKey) async {
    try {
      QuerySnapshot _resultSeller =
          await UserCollection.userRoleList(lastDocument, MyConstant.guideName);
      final isLastPage = _resultSeller.docs.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_resultSeller.docs);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(_resultSeller.docs, nextPageKey);
        lastDocument = _resultSeller.docs.last;
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  onRefresh() {
    setState(() {
      lastDocument = null;
    });
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorGuide,
        title: Form(
          child: Search(
            searchController: searchController,
            onSearch: onSearch,
            labelText: 'ค้นหาชื่อไกด์ :',
            colorIcon: MyConstant.themeApp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (contect) => CreateGuide(),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
          )
        ],
      ),
      body: isSearch
          ? FutureBuilder<QuerySnapshot>(
              future: UserCollection.searchUser(
                  searchController.text, MyConstant.buyerName),
              builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const BadRequestError();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List guides = snapshot.data!.docs;
                  if (guides.isEmpty) {
                    return const SearchResultFound();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: guides.length,
                    itemBuilder: (builder, index) => buildCardGuide(
                        size,
                        sizeHeight,
                        guides[index]["fullName"],
                        guides[index]["phoneNumber"],
                        guides[index]["role"]),
                  );
                }
                return const PouringHourGlass();
              },
            )
          : RefreshIndicator(
              onRefresh: () => Future.sync(() => onRefresh()),
              child: PagedListView<int, QueryDocumentSnapshot>(
                pagingController: _pagingController,
                builderDelegate:
                    PagedChildBuilderDelegate<QueryDocumentSnapshot>(
                  itemBuilder: (context, item, index) {
                    return buildCardGuide(
                      size,
                      sizeHeight,
                      item.get("fullName"),
                      item.get("phoneNumber"),
                      item.get("role"),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (_) =>
                      const BadRequestError(),
                  noItemsFoundIndicatorBuilder: (ctx) => const ShowDataEmpty(),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const PouringHourGlass(),
                  noMoreItemsIndicatorBuilder: (context) => const Center(
                    child: Text("ไม่มีข้อมูล"),
                  ),
                  newPageErrorIndicatorBuilder: (context) =>
                      const BadRequestError(),
                  newPageProgressIndicatorBuilder: (context) =>
                      CircularProgressIndicator(
                    color: MyConstant.themeApp,
                  ),
                ),
              ),
            ),
    );
  }

  Card buildCardGuide(double size, double sizeHeight, String fullName,
      String phoneNumber, String role) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        width: size * 1,
        height: 120,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: size * 0.2,
                    height: 70,
                    child: Icon(
                      Icons.person_outline,
                      color: MyConstant.colorGuide,
                      size: 50,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: MyConstant.colorGuide, width: 3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: size * 0.7,
                      margin: EdgeInsets.only(left: size * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.library_books,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    fullName,
                                    style: TextStyle(
                                      color: MyConstant.colorGuide,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                phoneNumber,
                                style: TextStyle(
                                  color: MyConstant.colorGuide,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                role,
                                style: TextStyle(
                                  color: MyConstant.colorGuide,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
