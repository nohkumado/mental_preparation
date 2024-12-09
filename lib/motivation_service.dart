import 'core/motivation_item.dart';

class MotivationService {
  void mergeActions(List<MotivationItem> data, Map<String, String> actions) {
    data.forEach((element) {
      if (actions.containsKey(element.label)) {
        element.action = actions[element.label]!;
      }
    });
  }

  void fillForm(List<MotivationItem> data, Map<String, dynamic> incomingData) {
    data.forEach((element) {
      if (incomingData.containsKey(element.label)) {
        element.note = incomingData[element.label]['note'];
        element.commentary = incomingData[element.label]['commentary'];
        if (incomingData[element.label].containsKey('action')) {
          element.action = incomingData[element.label]['action'];
        }
      }
    });
  }
}