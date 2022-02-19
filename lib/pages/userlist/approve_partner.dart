import 'package:chanthaburi_app/pages/userlist/component/card_partner.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/bad_request_error.dart';
import 'package:chanthaburi_app/widgets/fetch/search_result_found.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ApprovePartner extends StatefulWidget {
  final String textSearch;
  final bool isSearch;
  const ApprovePartner(
      {Key? key, required this.isSearch, required this.textSearch})
      : super(key: key);

  @override
  _ApprovePartnerState createState() => _ApprovePartnerState();
}

class _ApprovePartnerState extends State<ApprovePartner> {
  TextEditingController searchController = TextEditingController();
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

  Future<void> loadMoreBuyers(int pageKey) async {
    try {
      QuerySnapshot _resultBuyer =
          await UserCollection.approveList(lastDocument);
      final isLastPage = _resultBuyer.docs.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_resultBuyer.docs);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(_resultBuyer.docs, nextPageKey);
        lastDocument = _resultBuyer.docs.last;
      }
    } catch (e) {
      print(e.toString());
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

  onApprove(
    String docId,
    String fullName,
    String role,
    String phoneNumber,
    String profileRef,
    String email,
  ) async {
    late BuildContext dialogContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        dialogContext = context;
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> _response = await UserCollection.onApprove(
      docId,
      fullName,
      role,
      phoneNumber,
      profileRef,
      email,
    );
    Navigator.pop(dialogContext);
    showDialog(
      context: context,
      builder: (BuildContext showContext) {
        dialogContext = context;
        return ResponseDialog(response: _response);
      },
    );
    setState(() {
      lastDocument = null;
    });
    _pagingController.refresh();
  }

  onUnApprove(
    String docId,
  ) async {
    late BuildContext dialogContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        dialogContext = context;
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> _response = await UserCollection.unApprove(docId);
    Navigator.pop(dialogContext);
    showDialog(
      context: context,
      builder: (BuildContext showContext) {
        dialogContext = context;
        return ResponseDialog(response: _response);
      },
    );
    setState(() {
      lastDocument = null;
    });
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: widget.isSearch && widget.textSearch.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () => Future.sync(() => onRefresh()),
              child: FutureBuilder<QuerySnapshot>(
                future: UserCollection.searchApprovePartner(widget.textSearch),
                builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const BadRequestError();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    List _sellers = snapshot.data!.docs
                        .where((element) =>
                            element["role"] == MyConstant.sellerName)
                        .toList();
                    if (_sellers.isEmpty) {
                      return const SearchResultFound();
                    }
                    return ListView.builder(
                      itemCount: _sellers.length,
                      itemBuilder: (builder, index) => CardPartner(
                        role: _sellers[index]['role'],
                        fullName: _sellers[index]['fullName'],
                        phoneNumber: _sellers[index]['phoneNumber'],
                        onApprove: onApprove,
                        onUnApprove: onUnApprove,
                        docId: _sellers[index].id,
                        email: _sellers[index]['email'],
                        profileRef: _sellers[index]['profileRef'],
                      ),
                    );
                  }
                  return const PouringHourGlass();
                },
              ),
            )
          : RefreshIndicator(
              onRefresh: () => Future.sync(() => onRefresh()),
              child: PagedListView<int, QueryDocumentSnapshot>(
                pagingController: _pagingController,
                builderDelegate:
                    PagedChildBuilderDelegate<QueryDocumentSnapshot>(
                  itemBuilder: (context, item, index) {
                    return CardPartner(
                      fullName: item.get("fullName"),
                      role: item.get("role"),
                      phoneNumber: item.get("phoneNumber"),
                      profileRef: item.get("profileRef"),
                      email: item.get("email"),
                      docId: item.id,
                      onApprove: onApprove,
                      onUnApprove: onUnApprove,
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
                    color: MyConstant.colorStore,
                  ),
                ),
              ),
            ),
    );
  }
}
