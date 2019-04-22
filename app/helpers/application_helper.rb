module ApplicationHelper
  require "uri"

def text_url_to_link text #テキストをリンクに(音源URL用)

  URI.extract(text, ['http','https'] ).uniq.each do |url|
    sub_text = ""
    sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

    text.gsub!(url, sub_text)
  end

  return text
end

def noreply(current_user,noreply_array)
  currentEntries = current_user.entries
    myRoomIds = []

    currentEntries.each do |entry|
    myRoomIds << entry.room.id #自分が入っているRoomのidの情報
  end

  anotherEntries = Entry.where(room_id: myRoomIds).where('user_id != ?',current_user.id)

  anotherEntries.reverse.each do |e|
          e.room.messages.each_with_index do |em,index|
            if index == e.room.messages.size - 1
              if em.user_id != current_user.id
              noreply_array << 1
              end
        end
    end
  end
  noreply_count = noreply_array.count
end

end
