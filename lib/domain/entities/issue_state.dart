import '../../data/models/generated/generated_models.dart';

enum IssueStateType { open, closed }

extension StateTypeX on StateType {
  IssueStateType get issueState {
    if (value == 'open') return IssueStateType.open;
    return IssueStateType.closed;
  }

  bool get isOpen => value == 'open';
  bool get isClosed => value == 'closed';
}
