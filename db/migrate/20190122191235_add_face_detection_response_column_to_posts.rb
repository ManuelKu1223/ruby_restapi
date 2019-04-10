class AddFaceDetectionResponseColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :face_detection_response, :jsonb
  end
end
