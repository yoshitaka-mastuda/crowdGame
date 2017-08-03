# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#初期データ書く　rake db seed

Category.create(:category_id => '0', :name => '天気')
Category.create(:category_id => '1', :name => '混雑')
Category.create(:category_id => '2', :name => '景観')
Category.create(:category_id => '3', :name => '交通')
Category.create(:category_id => '4', :name => 'イベント')
Category.create(:category_id => '5', :name => '食事')
Category.create(:category_id => '6', :name => '観光地')
Category.create(:category_id => '7', :name => 'その他')

Reason.create(:reason_id => '0', :name => '京都と関係がないから')
Reason.create(:reason_id => '1', :name => '観光と関係がないから')
Reason.create(:reason_id => '2', :name => '様子が分からないから')
Reason.create(:reason_id => '3', :name => '去年の7月10日以前のツイートだから')
Reason.create(:reason_id => '4', :name => '宣伝や広告、botだから')
Reason.create(:reason_id => '5', :name => 'その他')

State.create(:state_id => '0', :state_name => 'ページ読み込み完了')
State.create(:state_id => '1', :state_name => 'ツイート表示開始')
State.create(:state_id => '2', :state_name => 'ツイート表示終了')
State.create(:state_id => '3', :state_name => '送信')
State.create(:state_id => '4', :state_name => '10分マウス停止')
State.create(:state_id => '5', :state_name => 'マウス動作再開')

State.create(:state_id => '10', :state_name => 'Q1（はい）選択')
State.create(:state_id => '11', :state_name => 'Q1（いいえ）選択')
State.create(:state_id => '12', :state_name => 'Q1（ツイートが表示されない）選択')

State.create(:state_id => '30', :state_name => 'Q2（天気）選択')
State.create(:state_id => '31', :state_name => 'Q2（混雑）選択')
State.create(:state_id => '32', :state_name => 'Q2（景観）選択')
State.create(:state_id => '33', :state_name => 'Q2（交通）選択')
State.create(:state_id => '34', :state_name => 'Q2（イベント）選択')
State.create(:state_id => '35', :state_name => 'Q2（食事）選択')
State.create(:state_id => '36', :state_name => 'Q2（観光地）選択')
State.create(:state_id => '37', :state_name => 'Q2（その他）選択')
State.create(:state_id => '40', :state_name => 'Q2（天気）選択解除')
State.create(:state_id => '41', :state_name => 'Q2（混雑）選択解除')
State.create(:state_id => '42', :state_name => 'Q2（景観）選択解除')
State.create(:state_id => '43', :state_name => 'Q2（交通）選択解除')
State.create(:state_id => '44', :state_name => 'Q2（イベント）選択解除')
State.create(:state_id => '45', :state_name => 'Q2（食事）選択解除')
State.create(:state_id => '46', :state_name => 'Q2（観光地）選択解除')
State.create(:state_id => '47', :state_name => 'Q2（その他）選択解除')

State.create(:state_id => '50', :state_name => 'Q2（京都と関係がないから）選択')
State.create(:state_id => '51', :state_name => 'Q2（観光と関係がないから）選択')
State.create(:state_id => '52', :state_name => 'Q2（様子が分からないから）選択')
State.create(:state_id => '53', :state_name => 'Q2（去年の7月10日以前のツイートだから）選択')
State.create(:state_id => '54', :state_name => 'Q2（去年の7月10日以前のツイートだから）選択')
State.create(:state_id => '55', :state_name => 'Q2（その他）選択')
State.create(:state_id => '60', :state_name => 'Q2（京都と関係がないから）選択解除')
State.create(:state_id => '61', :state_name => 'Q2（観光と関係がないから）選択解除')
State.create(:state_id => '62', :state_name => 'Q2（様子が分からないから）選択解除')
State.create(:state_id => '63', :state_name => 'Q2（去年の7月10日以前のツイートだから）選択解除')
State.create(:state_id => '64', :state_name => 'Q2（宣伝や広告、botだから）選択解除')
State.create(:state_id => '65', :state_name => 'Q2（その他）選択解除')


State.create(:state_id => '20', :state_name => 'Q3テキストエリアIN')
State.create(:state_id => '21', :state_name => 'Q3テキストエリアINPUT')
State.create(:state_id => '22', :state_name => 'Q3テキストエリアOUT')
State.create(:state_id => '23', :state_name => 'Q3テキストエリアPASTE')