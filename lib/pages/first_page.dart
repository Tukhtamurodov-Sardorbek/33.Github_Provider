import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_page/view_models/search_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FindUser viewModel = FindUser();

  @override
  void initState() {
    viewModel.loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => viewModel,
        child:
            Consumer<FindUser>(builder: (BuildContext context, model, index) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: viewModel.accountController,
                    focusNode: viewModel.accountFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff3d3d47),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        labelText: 'Username',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        floatingLabelStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        prefixIcon: const Icon(Icons.person_outline_sharp,
                            color: Colors.white54),
                        suffixIcon: viewModel.isNotEmpty
                            ? IconButton(
                                splashRadius: 1,
                                icon: const Icon(CupertinoIcons.clear,
                                    size: 18, color: Colors.white),
                                onPressed: () {
                                  viewModel.clear();
                                })
                            : viewModel.history.isNotEmpty
                                ? PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Colors.white54, size: 26),
                                    itemBuilder: (BuildContext context) {
                                      return viewModel.history.reversed
                                          .map<PopupMenuItem<String>>(
                                              (String value) {
                                        return PopupMenuItem(
                                            padding: EdgeInsets.zero,
                                            value: value,
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      4.0, 0.0, 0.0, 0.0),
                                              isThreeLine: false,
                                              title: Text(
                                                value,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              trailing: IconButton(
                                                  splashRadius: 1,
                                                  icon: const Icon(
                                                      CupertinoIcons.trash_fill,
                                                      size: 22,
                                                      color: Color(0xffff000f)),
                                                  onPressed: () {
                                                    viewModel.deleteHistory(value);
                                                  }),
                                            ));
                                      }).toList();
                                    },
                                    onSelected: (String value) {
                                      viewModel.update(value);
                                    },
                                  )
                                : const SizedBox.shrink(),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.white54, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.white54, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.white54, width: 2))),
                    onChanged: (String txt) {
                      viewModel.change(txt);
                    },
                    onSubmitted: (String account) {
                      viewModel.storeHistory(account);
                      viewModel.findUser(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    height: 42,
                    color: const Color(0xff02d800),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: viewModel.isLoading
                        ? const Center(
                            child: SizedBox(
                                height: 26,
                                width: 26,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                )))
                        : const Text('Find user',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                    onPressed: () {
                      viewModel.storeHistory(viewModel.accountController.text);
                      viewModel
                          .findUser(context)
                          .timeout(const Duration(seconds: 5), onTimeout: () {

                        viewModel.onTimeOut(context);
                      });
                    },
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
