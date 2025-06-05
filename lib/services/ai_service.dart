import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AiService {
  static const String _openAiApiKey = 'OPEN_AI_KEY'; // Replace with your actual API key
  static const String _openAiBaseUrl = 'https://api.openai.com/v1';
  
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<String> processQuery(String userQuery) async {
    try {
      developer.log('🤖 AI Service: Processing query: "$userQuery"', name: 'AiService');
      
      // First, analyze the query to determine if it needs database access
      final analysisResult = await _analyzeQuery(userQuery);
      developer.log('📊 AI Service: Query analysis result: $analysisResult', name: 'AiService');
      
      if (analysisResult['needsDatabase'] == true) {
        developer.log('🗄️ AI Service: Query requires database access', name: 'AiService');
        
        // Generate SQL query based on user input
        final sqlQuery = await _generateSqlQuery(userQuery);
        developer.log('📝 AI Service: Generated SQL: $sqlQuery', name: 'AiService');
        
        if (sqlQuery.isNotEmpty) {
          // Execute the query and get results
          final queryResults = await _executeQuery(sqlQuery);
          developer.log('📋 AI Service: Query results count: ${queryResults.length}', name: 'AiService');
          
          // Format the results into a natural language response
          final response = await _formatResponse(userQuery, queryResults, sqlQuery);
          developer.log('✅ AI Service: Generated response length: ${response.length} chars', name: 'AiService');
          return response;
        } else {
          developer.log('⚠️ AI Service: Empty SQL query generated', name: 'AiService');
        }
      } else {
        developer.log('💬 AI Service: Using general response (no database access needed)', name: 'AiService');
      }
      
      // For general questions, use OpenAI directly
      final generalResponse = await _getGeneralResponse(userQuery);
      developer.log('✅ AI Service: Generated general response', name: 'AiService');
      return generalResponse;
      
    } catch (e, stackTrace) {
      developer.log('❌ AI Service: Error processing query: $e', name: 'AiService', error: e, stackTrace: stackTrace);
      return 'I apologize, but I encountered an error while processing your request. Please try again or contact support if the issue persists. Error: ${e.toString()}';
    }
  }

  static Future<Map<String, dynamic>> _analyzeQuery(String query) async {
    developer.log('🔍 AI Service: Analyzing query for database access need', name: 'AiService');
    
    final prompt = '''
Analyze this user query and determine if it requires database access:

Query: "$query"

Respond with JSON format:
{
  "needsDatabase": true/false,
  "queryType": "product_search", "expiry_check", "stock_analysis", "sales_report", "purchase_report", "general",
  "intent": "brief description of what user wants"
}

Database-related queries include:
- Product information, stock levels, inventory
- Expiry dates, batch information
- Sales and purchase data
- Stock reports and analytics
- Supplier information
- Any data that would be in a stock management system

General queries include:
- How to use the system
- General business advice
- Non-data specific questions''';

    try {
      developer.log('📤 AI Service: Sending analysis request to OpenAI', name: 'AiService');
      final response = await _callOpenAI(prompt, maxTokens: 150);
      developer.log('📥 AI Service: Received analysis response: $response', name: 'AiService');
      final result = json.decode(response);
      developer.log('✅ AI Service: Successfully parsed analysis result', name: 'AiService');
      return result;
    } catch (e, stackTrace) {
      developer.log('❌ AI Service: Error analyzing query: $e', name: 'AiService', error: e, stackTrace: stackTrace);
      return {'needsDatabase': false, 'queryType': 'general'};
    }
  }

  static Future<String> _generateSqlQuery(String userQuery) async {
    // If using mock responses (API key not configured), return appropriate mock SQL
    if (_openAiApiKey == 'OPEN_AI_KEY') {
      developer.log('⚠️ AI Service: Using mock SQL query (API key not configured)', name: 'AiService');
      return _getMockSqlQuery(userQuery);
    }

    final databaseSchema = '''
Database Schema for Stock Management System:

Core Tables:
1. products - Product master data
   - id (uuid), product_name, product_code, generic_name, manufacturer
   - category_id, formulation_id, base_cost_per_strip, mrp_per_strip
   - min_stock_level_godown, min_stock_level_mr
   - created_at, updated_at, is_deleted

2. product_batches - Batch tracking
   - id (uuid), product_id, batch_number, manufacturing_date, expiry_date
   - quantity_strips, cost_per_strip, created_at

3. stock_transactions - All stock movements (main transaction table)
   - id (uuid), product_id, batch_id, transaction_type
   - quantity_strips, cost_per_strip_at_transaction
   - location_type_source, location_id_source
   - location_type_destination, location_id_destination
   - created_at, transaction_date

4. stock_purchases - Purchase records
   - id (uuid), product_id, batch_id, supplier_id
   - quantity_strips, cost_per_strip, total_amount
   - purchase_date, created_at

5. stock_sales - Sales records
   - id (uuid), product_id, batch_id, transaction_type
   - quantity_strips, selling_price_per_strip, total_amount
   - sale_date, created_at

6. stock_adjustments - Stock adjustments (RLS enabled)
   - id (uuid), product_id, batch_id, adjustment_type
   - quantity_change, reason, notes
   - adjusted_by, adjustment_date, created_at

7. products_stock_status - Current stock levels
   - product_id, batch_id, location_type, location_id
   - current_quantity_strips, cost_per_strip, last_updated_at

8. product_categories - Product categories
   - id (uuid), category_name, description, created_at

9. product_formulations - Product formulations
   - id (uuid), formulation_name, description, created_at

10. suppliers - Supplier information
    - id (uuid), supplier_name, contact_person, phone, email, address
    - created_at, updated_at, is_active

11. profiles - User profiles (with RLS)
    - user_id (uuid), name, email, role (admin/user)
    - created_at, updated_at

12. mr_stock_summary - MR stock summary
    - id (uuid), mr_id, product_id, batch_id
    - current_stock, last_updated

13. packaging_templates - Packaging templates
    - id (uuid), template_name, strips_per_box
    - created_at, is_active

Important Views:
- stock_transactions_view - Comprehensive view of all stock movements with joins
- closing_stock_report - Daily closing stock reports

Security Notes:
- RLS (Row Level Security) is enabled on stock_adjustments and profiles
- Only authenticated users can access data
- Admin role required for modifications on stock_adjustments
- Use execute_safe_query() function for safe database access''';

    final prompt = '''
Based on this database schema, generate a PostgreSQL query for the following request:

$databaseSchema

User Query: "$userQuery"

Generate ONLY the SQL query, no explanations. The query should:
1. Be safe and read-only (SELECT statements only)
2. Include appropriate JOINs when needed
3. Use proper WHERE clauses for filtering
4. Include ORDER BY and LIMIT when appropriate
5. Handle date comparisons properly
6. Return meaningful column names

If the query involves expiry dates, use current date comparisons.
If asking for "next 30 days" or similar, use date arithmetic.

SQL Query:''';

    try {
      final response = await _callOpenAI(prompt, maxTokens: 300);
      return response.trim();
    } catch (e) {
      return '';
    }
  }

  static String _getMockSqlQuery(String userQuery) {
    final lowerQuery = userQuery.toLowerCase();
    
    if (lowerQuery.contains('expiry') || lowerQuery.contains('expire')) {
      return '''
SELECT 
  p.product_name,
  pb.batch_number,
  pb.expiry_date,
  pss.current_quantity_strips
FROM products p
JOIN product_batches pb ON p.id = pb.product_id
JOIN products_stock_status pss ON pb.id = pss.batch_id
WHERE pb.expiry_date <= CURRENT_DATE + INTERVAL '30 days'
  AND pss.current_quantity_strips > 0
ORDER BY pb.expiry_date ASC
LIMIT 20''';
    }
    
    if (lowerQuery.contains('stock') || lowerQuery.contains('inventory')) {
      return '''
SELECT 
  p.product_name,
  pc.category_name,
  SUM(pss.current_quantity_strips) as total_stock,
  p.min_stock_level_godown
FROM products p
JOIN product_categories pc ON p.category_id = pc.id
JOIN products_stock_status pss ON p.id = pss.product_id
WHERE pss.current_quantity_strips > 0
GROUP BY p.id, p.product_name, pc.category_name, p.min_stock_level_godown
ORDER BY total_stock DESC
LIMIT 20''';
    }
    
    if (lowerQuery.contains('sales') || lowerQuery.contains('purchase')) {
      return '''
SELECT 
  p.product_name,
  COUNT(*) as transaction_count,
  SUM(st.quantity_strips) as total_quantity,
  AVG(st.cost_per_strip_at_transaction) as avg_cost
FROM stock_transactions st
JOIN products p ON st.product_id = p.id
WHERE st.created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.id, p.product_name
ORDER BY total_quantity DESC
LIMIT 15''';
    }
    
    // Default query for general requests
    return '''
SELECT 
  p.product_name,
  pc.category_name,
  COUNT(pb.id) as batch_count,
  SUM(pss.current_quantity_strips) as total_stock
FROM products p
JOIN product_categories pc ON p.category_id = pc.id
LEFT JOIN product_batches pb ON p.id = pb.product_id
LEFT JOIN products_stock_status pss ON pb.id = pss.batch_id
GROUP BY p.id, p.product_name, pc.category_name
ORDER BY total_stock DESC NULLS LAST
LIMIT 10''';
  }

  static Future<List<Map<String, dynamic>>> _executeQuery(String sqlQuery) async {
    try {
      developer.log('🔒 AI Service: Validating SQL query security', name: 'AiService');
      
      // Validate that it's a SELECT query for security
      if (!sqlQuery.trim().toLowerCase().startsWith('select')) {
        developer.log('❌ AI Service: Non-SELECT query rejected for security', name: 'AiService');
        throw Exception('Only SELECT queries are allowed');
      }

      developer.log('🗄️ AI Service: Executing safe query via RPC', name: 'AiService');
      developer.log('📝 AI Service: SQL Query: $sqlQuery', name: 'AiService');
      
      final response = await _supabase.rpc('execute_safe_query', params: {
        'query_text': sqlQuery,
      });

      developer.log('📊 AI Service: Raw database response type: ${response.runtimeType}', name: 'AiService');
      developer.log('📊 AI Service: Raw database response: $response', name: 'AiService');

      if (response is List) {
        final results = List<Map<String, dynamic>>.from(response);
        developer.log('✅ AI Service: Successfully parsed ${results.length} records from database', name: 'AiService');
        return results;
      } else {
        developer.log('✅ AI Service: Single record response from database', name: 'AiService');
        return [response as Map<String, dynamic>];
      }
    } catch (e, stackTrace) {
      developer.log('❌ AI Service: Database query error: $e', name: 'AiService', error: e, stackTrace: stackTrace);
      
      // If RPC doesn't exist, try to provide helpful error message
      if (e.toString().contains('execute_safe_query')) {
        developer.log('⚠️ AI Service: execute_safe_query function not found, may need to run migration', name: 'AiService');
        throw Exception('Database function not available. Please ensure the AI query function migration has been applied.');
      }
      
      throw Exception('Database query failed: $e');
    }
  }

  static Future<String> _formatResponse(String originalQuery, List<Map<String, dynamic>> queryResults, String sqlQuery) async {
    developer.log('📝 AI Service: Formatting response for ${queryResults.length} results', name: 'AiService');
    
    final limitedResults = queryResults.take(10).toList(); // Limit results for token efficiency
    final resultsJson = json.encode(limitedResults);
    
    developer.log('📊 AI Service: Limited results to ${limitedResults.length} records for formatting', name: 'AiService');
    developer.log('📋 AI Service: Results JSON length: ${resultsJson.length} characters', name: 'AiService');
    
    final prompt = '''
User asked: "$originalQuery"

SQL Query executed: $sqlQuery

Query Results (JSON): $resultsJson

Format this data into a natural, helpful response for the user. Include:
1. A direct answer to their question
2. Key insights from the data
3. Relevant numbers and details
4. If no results, explain why and suggest alternatives

Make the response conversational and easy to understand. If there are many results, summarize the key points.''';

    try {
      developer.log('📤 AI Service: Sending formatting request to OpenAI', name: 'AiService');
      final response = await _callOpenAI(prompt, maxTokens: 500);
      developer.log('✅ AI Service: Successfully formatted response', name: 'AiService');
      return response;
    } catch (e, stackTrace) {
      developer.log('❌ AI Service: Error formatting response: $e', name: 'AiService', error: e, stackTrace: stackTrace);
      return 'I found ${queryResults.length} results for your query, but encountered an error formatting the response. Please try rephrasing your question. Error: ${e.toString()}';
    }
  }

  static Future<String> _getGeneralResponse(String query) async {
    final prompt = '''
You are an AI assistant for a medical stock management system. The user asked: "$query"

Provide a helpful response about stock management, inventory control, or general business advice related to pharmaceutical/medical stock management.

Keep the response concise, practical, and relevant to stock management.''';

    try {
      return await _callOpenAI(prompt, maxTokens: 300);
    } catch (e) {
      return 'I\'m here to help with your stock management questions. Could you please rephrase your question or ask about specific aspects like inventory levels, product information, or reports?';
    }
  }

  static Future<String> _callOpenAI(String prompt, {int maxTokens = 500}) async {
    developer.log('🤖 AI Service: Calling OpenAI API with ${maxTokens} max tokens', name: 'AiService');
    
    if (_openAiApiKey == 'YOUR_OPENAI_API_KEY') {
      developer.log('⚠️ AI Service: Using mock response (API key not configured)', name: 'AiService');
      // Return a mock response when API key is not configured
      return _getMockResponse(prompt);
    }

    try {
      developer.log('📤 AI Service: Sending request to OpenAI', name: 'AiService');
      
      final response = await http.post(
        Uri.parse('$_openAiBaseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAiApiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful AI assistant for a medical stock management system. Provide accurate, concise, and relevant responses.'
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'max_tokens': maxTokens,
          'temperature': 0.7,
        }),
      );

      developer.log('📥 AI Service: OpenAI response status: ${response.statusCode}', name: 'AiService');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'].toString().trim();
        developer.log('✅ AI Service: Successfully received OpenAI response (${content.length} chars)', name: 'AiService');
        return content;
      } else {
        developer.log('❌ AI Service: OpenAI API error: ${response.statusCode} - ${response.body}', name: 'AiService');
        throw Exception('OpenAI API error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      developer.log('❌ AI Service: Error calling OpenAI: $e', name: 'AiService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static String _getMockResponse(String prompt) {
    // Mock responses for demonstration when OpenAI API key is not configured
    final lowerPrompt = prompt.toLowerCase();
    
    if (lowerPrompt.contains('expiry') || lowerPrompt.contains('expire')) {
      return '''Based on your current inventory, here are products expiring in the next 30 days:

• Paracetamol 500mg - Batch #PAR001 (15 strips) - Expires: March 15, 2024
• Amoxicillin 250mg - Batch #AMX002 (8 strips) - Expires: March 22, 2024
• Ibuprofen 400mg - Batch #IBU003 (12 strips) - Expires: March 28, 2024

Recommendation: Consider prioritizing sales of these items or check with suppliers for exchange policies.''';
    }
    
    if (lowerPrompt.contains('stock') || lowerPrompt.contains('inventory')) {
      return '''Current Stock Summary:

📊 Total Products: 156
📦 Total Stock Value: ₹2,45,680
⚠️ Low Stock Items: 12
🔴 Out of Stock: 3

Top Categories by Value:
1. Antibiotics - ₹85,420
2. Pain Relief - ₹62,150
3. Vitamins - ₹45,890

Would you like me to provide more details about any specific category or product?''';
    }
    
    if (lowerPrompt.contains('sales') || lowerPrompt.contains('purchase')) {
      return '''Recent Activity Summary:

📈 This Month's Sales: ₹1,25,450
📉 Last Month: ₹1,18,200 (+6.1%)

🛒 Recent Purchases: ₹85,600
📊 Top Selling Products:
1. Paracetamol 500mg - 145 strips
2. Crocin Advance - 98 strips
3. Vitamin D3 - 76 strips

Your inventory turnover is healthy with good demand for pain relief medications.''';
    }
    
    return '''I'm here to help you with your stock management queries! I can assist with:

• 📦 Inventory levels and stock status
• 📅 Product expiry tracking
• 📊 Sales and purchase reports
• 🔍 Product search and details
• 📈 Stock analytics and insights

Please note: To get real-time data, configure your OpenAI API key in the service settings.

What specific information would you like to know about your inventory?''';
  }
}