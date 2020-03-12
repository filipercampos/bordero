
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/dto/cheque_client.dart';
import 'package:bordero/enums/cheque_view_type.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/repository/cheque_repository.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/enums/sort_criteria_cheque.dart';
import 'package:rxdart/subjects.dart';

class ChequeBloc extends BlocBase {
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();
  final _chequesController = BehaviorSubject<List<Cheque>>();
  final _chequesClientController = BehaviorSubject<List<ChequeClient>>();
  final _chequeViewController = BehaviorSubject<bool>();

  Stream<bool> get outLoading => _loadingController.stream;

  Stream<bool> get outCreated => _createdController.stream;

  Stream<List<Cheque>> get outCheques => _chequesController.stream;

  Stream<List<ChequeClient>> get outChequesClient =>
      _chequesClientController.stream;

  Stream<bool> get outChequeViewType => _chequeViewController.stream;

  final ChequeRepository _repository = RepositoryHelper().chequeRepository;

  List<ChequeClient> chequesClient;

  ChequeBloc();

  @override
  void dispose() {
    super.dispose();
    _loadingController.close();
    _createdController.close();
    _chequesController.close();
    _chequesClientController.close();
    _chequeViewController.close();
  }

  void loadCheques() async {
     await getAllCheques();
    chequesClient = await getChequesGroupByClient();
    setOrderCriteria(SortCriteriaCheque.LOW_VALUE);
  }

  Future<List<Cheque>> getAllCheques() async {
    List<Cheque> cheques = await _repository.all();
    _chequesController.add(cheques);
    return cheques;
  }

  Future<List<Cheque>> getChequesFromDate(initialValue, endValue) async {
    List<Cheque> cheques = await _repository.getChequeFromDate(initialValue, endValue);
    _chequesController.add(cheques);
    return cheques;
  }

  Future<List<ChequeClient>> getChequesGroupByClient() async {
    List<ChequeClient> chequesClients = await _repository.groupByClient();
    _chequesClientController.add(chequesClients);
    this.chequesClient = chequesClients;
    return chequesClients;
  }

  Future<List<ChequeClient>> getChequesGroupByClientFromDate(initialValue, endValue) async {
    List<ChequeClient> chequesClients = await _repository.groupByClientFromDate(initialValue, endValue);
    _chequesClientController.add(chequesClients);
    print(chequesClients);
    return chequesClients;
  }

  void setOrderCriteria(SortCriteriaCheque criteria) {
    //compara double
    switch (criteria) {
      //menor pro maior
      case SortCriteriaCheque.HIGH_VALUE:
        _chequesController.value.sort((Cheque a, Cheque b) {
          var sa = a.dataVencimento.millisecondsSinceEpoch; //valorCheque.toDouble();
          var sb = b.dataVencimento.millisecondsSinceEpoch;// valorCheque.toDouble();

          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });

        break;
      //maior pro menor
      case SortCriteriaCheque.LOW_VALUE:
        _chequesController.value.sort((a, b) {
          var sa = a.dataVencimento.millisecondsSinceEpoch; //valorCheque.toDouble();
          var sb = b.dataVencimento.millisecondsSinceEpoch;// valorCheque.toDouble();

          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });

        break;
    }
    _chequesController.add(_chequesController.value);
    _orderCriteriaClient(criteria);
  }

  void _orderCriteriaClient(SortCriteriaCheque criteria) {
    //compara string
    switch (criteria) {
      //menor pro maior
      case SortCriteriaCheque.LOW_VALUE:
        _chequesClientController.value.sort((ChequeClient a, ChequeClient b) {
          int sa =
              a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase());
          int sb =
              b.clientName.toLowerCase().compareTo(a.clientName.toLowerCase());

          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });

        break;
      //maior pro menor
      case SortCriteriaCheque.HIGH_VALUE:
        _chequesClientController.value.sort((a, b) {
          int sa =
              a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase());
          int sb =
              b.clientName.toLowerCase().compareTo(a.clientName.toLowerCase());

          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }
    _chequesClientController.add(_chequesClientController.value);
  }

  //Salva a lista de cheques
  Future<bool> saveCheques(List<Cheque> cheques) async {
    try {
      _loadingController.add(true);
      int count = 0;

      for (Cheque cheque in cheques) {
        int id = await _repository.insert(cheque.toJson());
        if (id != 0) {
          cheque.id = id;
          count++;
        }
      }
      _createdController.add(true);
      _loadingController.add(false);
      return count == cheques.length;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  void repaintView(ChequeViewType view) {
    _chequeViewController.add(true);
  }

  Future<Cheque>getCheque(int id) async {
   return _repository.getCheque(id);

  }

}
