import 'dart:async';
import 'package:bloc/bloc.dart';

import '../events/matter_events.dart';
import 'matter_detail_state.dart';



class MatterDetailBloc extends Bloc<MatterEvent, MatterDetailState> {
  MatterDetailBloc(super.initialState);
}