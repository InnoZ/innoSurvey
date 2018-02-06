RSpec.describe AnswersController, type: :controller do
    context 'POST #answer_question_set' do
        before do
            @statement = create :statement 
            @choice = create :choice, statement: @statement
            #Request 
        end
        def send_request(json, format)
            post :answer_question_set, { 
                params: json,
                xhr: true, format: format }
        end 
        it 'should be sucessfull with correct json' do
            send_request({"answers":[{"statement_id":@statement.id,"selected_choices":[@choice.id]}]},'json')
            expect(response.status).to eq( 201 )
        end
        it 'should return http 422/unprocessable_entity with invalid statement reference' do
            send_request({"answers":[{"statement_id":42,"selected_choices":[@choice.id]}]},'json')
            expect(response.status).to eq( 422 )
        end
        it 'should return http 422/unprocessable_entity with invalid choice reference' do
            send_request({"answers":[{"statement_id":@statement.id,"selected_choices":[42]}]},'json')
            expect(response.status).to eq( 422 )
        end
        it 'should remove unpermitted json elements' do
            send_request({"answers":[{"statement_id":@statement.id,"selected_choices":[@choice.id]}],"another_param":"deny_me"},'json')
            expect(response.status).to eq( 201)
        end
        it 'should deny request with unpermitted json elements' do
            send_request({"answers":[{"statement":@statement.id,"selected_choices":["'drop table answers;"]}]},'json')
            expect(response.status).to eq( 422 )
        end
    end
    context 'GET #answer_question_set' do
        it 'should respond with right error' do
            get :answer_question_set, { 
                params: {"answers":[{"statement":42,"selected_choices":[12]}]},
                xhr: true, format: 'json'}
            expect(response.status).to eq( 422 )
        end
    end
end
