FactoryGirl.define do
  factory :post do
    note { Faker::Lorem.words(10).join(" ") }
    sequence(:created_at) { |n| Time.zone.now - n.hours }
    trait :html_note do
      note do Faker::Lorem.words(10).map do |w|
          "<p>#{w}</p>"
        end.join.html_safe
      end
    end
  end

end
