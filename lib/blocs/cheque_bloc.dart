import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/repository/cheque_repository.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/widgets/sort_criteria_cheque.dart';
import 'package:rxdart/subjects.dart';

class ChequeBloc extends BlocBase {
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();
  final _chequesController = BehaviorSubject<List<Cheque>>();

  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;
  Stream<List<Cheque>> get outCheques => _chequesController.stream;
  SortCriteriaCheque _criteria;

  @override
  void dispose() {
    super.dispose();
    _loadingController.close();
    _createdController.close();
  }
  void loadCheques(){
    getAllCheques();
  }

  Future<bool> saveCheques(List<Cheque> cheques) async {
    try {
      _loadingController.add(true);

      int count = 0;
      final repository = RepositoryHelper().chequeRepository;
      for (Cheque cheque in cheques) {
        int id = await repository.insert(cheque.toJson());
        if (id != 0) {
          cheque.id = id;
          count++;
        }
      }
      repository.close();

      _createdController.add(true);

      _loadingController.add(false);
      return count == cheques.length;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  Future<List<Cheque>> getAllCheques() async {
    ChequeRepository _repository = RepositoryHelper().chequeRepository;
    List<Cheque> cheques = List<Cheque>();
    await _repository.getAll().then((list) {
        list.forEach((map) => cheques.add(Cheque.fromJson(map)));
    });
    _chequesController.add(cheques);
    return cheques;
  }

  void setOrderCriteria(SortCriteriaCheque criteria) {
    this._criteria = criteria;
    _sort(_chequesController.value);
  }

  void _sort(cheques) {
    switch (_criteria) {
      //menor pro maior
      case SortCriteriaCheque.HIGH_VALUE:
        cheques.sort((Cheque a, Cheque b) {
          var sa = a.valorCheque.toDouble();
          var sb = b.valorCheque.toDouble();

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
        cheques.sort((a, b) {
          var sa = a.valorCheque.toDouble();
          var sb = b.valorCheque.toDouble();

          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }
    print("Ordenação");
    _chequesController.add(cheques);
  }

  
}
