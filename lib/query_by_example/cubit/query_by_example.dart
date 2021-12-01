import 'package:bloc/bloc.dart';
import 'package:talao/query_by_example/model/query.dart';

class QueryByExampleCubit extends Cubit<Query> {
  QueryByExampleCubit() : super(Query(type: '', credentialQuery: []));

  void setQueryByExampleCubit(queryByExample) {
    final _query = Query.fromJson(queryByExample);
    emit(_query);
  }
  void resetQueryByExampleCubit() {
    emit(Query(type: '', credentialQuery: []));
  }
}
