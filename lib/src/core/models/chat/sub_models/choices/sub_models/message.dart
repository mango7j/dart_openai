// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../image/enum.dart';
import 'sub_models/content.dart';
import 'sub_models/tool_call.dart';
export 'sub_models/content.dart';
export 'sub_models/tool_call.dart';

/// {@template openai_chat_completion_choice_message_model}
/// This represents the message of the [OpenAIChatCompletionChoiceModel] model of the OpenAI API, which is used and get returned while using the [OpenAIChat] methods.
/// {@endtemplate}
final class OpenAIChatCompletionChoiceMessageModel {
  /// The [role] of the message.
  final OpenAIChatMessageRole role;

  //! TODO: add the possibility to include images in the message content, see docs and do a non-breaking change.
  /// The [content] of the message.
  final List<OpenAIChatCompletionChoiceMessageContentItemModel>? content;

  /// The function that the model is requesting to call.
  final List<OpenAIResponseToolCall>? toolCalls;

  bool get hasToolCalls => toolCalls != null;

  @override
  int get hashCode {
    return role.hashCode ^ content.hashCode ^ toolCalls.hashCode;
  }

  /// {@macro openai_chat_completion_choice_message_model}
  const OpenAIChatCompletionChoiceMessageModel({
    required this.role,
    required this.content,
    this.toolCalls,
  });

  /// This is used  to convert a [Map<String, dynamic>] object to a [OpenAIChatCompletionChoiceMessageModel] object.
  factory OpenAIChatCompletionChoiceMessageModel.fromMap(
    Map<String, dynamic> json,
  ) {
    return OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.values
          .firstWhere((role) => role.name == json['role']),
      content: json['content'] != null
          ? dynamicContentFromField(json['content'])
          : null,
      toolCalls: json['tool_calls'] != null
          ? (json['tool_calls'] as List)
              .map((toolCall) => OpenAIResponseToolCall.fromMap(toolCall))
              .toList()
          : null,
    );
  }

// This method used to convert the [OpenAIChatCompletionChoiceMessageModel] to a [Map<String, dynamic>] object.
  Map<String, dynamic> toMap() {
    return {
      "role": role.name,
      "content": content?.map((contentItem) => contentItem.toMap()).toList(),
      if (toolCalls != null && role == OpenAIChatMessageRole.assistant)
        "tool_calls": toolCalls!.map((toolCall) => toolCall.toMap()).toList(),
    };
  }

  @override
  String toString() {
    String str = 'OpenAIChatCompletionChoiceMessageModel('
        'role: $role, '
        'content: $content, ';

    if (toolCalls != null) {
      str += 'toolCalls: $toolCalls, ';
    }
    str += ')';

    return str;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OpenAIChatCompletionChoiceMessageModel &&
        other.role == role &&
        other.content == content &&
        other.toolCalls == toolCalls;
  }

//! TODO: make method for all other kind of resending messages.

  RequestFunctionMessage asRequestFunctionMessage({
    required String toolCallId,
  }) {
    return RequestFunctionMessage(
      content: this.content,
      role: this.role,
      toolCallId: toolCallId,
    );
  }

  static List<OpenAIChatCompletionChoiceMessageContentItemModel>
      dynamicContentFromField(
    dynamic fieldData,
  ) {
    if (fieldData is String) {
      return [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(fieldData),
      ];
    } else if (fieldData is List) {
      return (fieldData as List).map(
        (item) {
          if (item is! Map) {
            throw Exception('Invalid content item');
          } else {
            final asMap = item as Map<String, dynamic>;

            return OpenAIChatCompletionChoiceMessageContentItemModel.fromMap(
              asMap,
            );
          }
        },
      ).toList();
    } else {
      throw Exception('Invalid content');
    }
  }
}

base class RequestFunctionMessage
    extends OpenAIChatCompletionChoiceMessageModel {
  final String toolCallId;

  RequestFunctionMessage({
    required super.role,
    required super.content,
    required this.toolCallId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "role": role.name,
      "content": content,
      "tool_call_id": toolCallId,
    };
  }
}
