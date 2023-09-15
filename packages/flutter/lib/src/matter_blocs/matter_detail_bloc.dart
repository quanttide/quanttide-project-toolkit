import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_quanttide_projects/src/api.dart';
import 'package:flutter_quanttide_projects/src/events/matter_events.dart';
import 'package:flutter_quanttide_projects/src/api_client.dart';

import '../events/matter_events.dart';
import 'matter_detail_state.dart';

class MatterDetailBloc extends Bloc<MatterEvent, Matter> {
  final ApiService apiService;

  MatterDetailBloc(this.apiService) : super(Matter.initial());

  @override
  Stream<Matter> mapEventToState(MatterEvent event) async* {
    if (event is MatterRetrieved) {
      // Handle matter detail retrieval
    } else if (event is MatterListed) {
      // Handle matter listing
    } else if (event is MatterCreated) {
      // Handle matter creation
    } else if (event is MatterUpdated) {
      // Handle matter updating
    } else if (event is MatterPartialUpdated) {
      // Handle partial matter updating
    } else if (event is MatterAssigned) {
      // Handle matter assignment
    } else if (event is MatterDestroyed) {
      // Handle matter deletion
    }
  }
}

mixin ProjectsAPIMixin on APIClient {
  // Methods for getting project and matter lists
}

class ProjectsAPIClient extends APIClient with ProjectsAPIMixin {
  ProjectsAPIClient({required super.apiRoot});
}