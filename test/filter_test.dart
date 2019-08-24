import 'package:flutter/material.dart';

class VoucherListLayout extends StatefulWidget {
  @override
  _VoucherListLayoutState createState() => _VoucherListLayoutState();
}

class _VoucherListLayoutState extends State<VoucherListLayout> {
  bool _showFilter = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: filterAppBar(context),
        body: Container(
          child: Column(
            children: <Widget>[
              VoucherListFilters(_showFilter),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return VoucherItemLayout(context);
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.library_add,
            size: 30,
          ),
          backgroundColor: Theme.of(context).accentColor,
          elevation: 6.0,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget filterAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      actions: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                maxLines: 1,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            setState(() {
              _showFilter = _showFilter == true ? false : true;
            });
          },
        )
      ],
    );
  }
}

class VoucherListFilters extends StatefulWidget {
  final bool _showFilter;

  VoucherListFilters(this._showFilter, {Key key}) : super(key: key);

  _VoucherListFiltersState createState() => _VoucherListFiltersState();
}

class _VoucherListFiltersState extends State<VoucherListFilters> {
  @override
  Widget build(BuildContext context) {
    if (widget._showFilter) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: SafeArea(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Row(
                    children: <Widget>[
                      DropdownButton(
                        onChanged: (String value) {},
                        value: "1",
                        style: TextStyle(color: Colors.white),
                        items: [
                          DropdownMenuItem(
                            value: "1",
                            child: Text(
                              "Praça 1",
                            ),
                          ),
                          DropdownMenuItem(
                            value: "2",
                            child: Text(
                              "Praça 2",
                            ),
                          ),
                          DropdownMenuItem(
                            value: "3",
                            child: Text(
                              "Praça 3",
                            ),
                          ),
                        ],
                      ),
                      FlatButton(
                        child: Text(
                          "Ativos",
                          style: TextStyle(
                              color: Colors.green[400],
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text(
                          "Inativos",
                          style: TextStyle(
                              color: Colors.red[400],
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 1,
      );
    }
  }
}

class VoucherItemLayout extends StatelessWidget {
  final BuildContext context;

  VoucherItemLayout(this.context);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          title: Text("123456"),
          subtitle: Text("VOUCHER"),
          leading: Icon(
            Icons.library_books,
            size: 25,
            color: Theme.of(context).accentColor,
          ),
          trailing: Icon(
            Icons.center_focus_weak,
            size: 25,
            color: Theme.of(context).accentColor,
          ),
          onTap: () {},
        ));
  }
}
