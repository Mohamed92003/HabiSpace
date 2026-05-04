
import '../../../../core/constants/api_constant.dart';
import '../../../../core/constants/dio_helper.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel> getConversation(int conversationId);
  Future<MessageModel> sendMessage(int conversationId, String body);
  Future<ConversationModel> startConversation(int agentUserId, int propertyId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<ConversationModel>> getConversations() async {
    final response = await DioHelper.get(
      path: ApiConstant.conversations,
      withAuth: true,
    );
    final data = response.data['data'] ?? response.data;
    return (data as List)
        .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ConversationModel> getConversation(int conversationId) async {
    final response = await DioHelper.get(
      path: '${ApiConstant.conversations}/$conversationId',
      withAuth: true,
    );
    final data = response.data['data'] ?? response.data;
    return ConversationModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<MessageModel> sendMessage(int conversationId, String body) async {
    final response = await DioHelper.post(
      path: '${ApiConstant.conversations}/$conversationId/${ApiConstant.messages}',
      data: {'body': body},
      withAuth: true,
    );
    final data = response.data['data'] ?? response.data;
    return MessageModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ConversationModel> startConversation(
      int agentUserId, int propertyId) async {
    final response = await DioHelper.post(
      path: ApiConstant.conversations,
      data: {
        'agent_user_id': agentUserId,
        'property_id': propertyId,
      },
      withAuth: true,
    );
    final data = response.data['data'] ?? response.data;
    return ConversationModel.fromJson(data as Map<String, dynamic>);
  }
}