class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  #is this allowed here
  include Rails.application.routes.url_helpers

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  def splash
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    #https://github.com/GoogleCloudPlatform/ruby-docs-samples/blob/master/vision/detect_faces.rb
    #https://cloud.google.com/vision/docs/reference/rest/v1/images/annotate
    
    #require "google/cloud/vision"

    #image_annotator_client = Google::Cloud::Vision::ImageAnnotator.new(version: :v1)
    #gcs_image_uri = "gs://gapic-toolkit/President_Barack_Obama.jpg"
    #source = { gcs_image_uri: gcs_image_uri }
    #image = { source: source }

    #image_path = rails_blob_path(, disposition: "attachment", only_path: true)
    #source = { image_uri: image_uri }
    #image = { source: source }
    #type = :FACE_DETECTION
    #features_element = { type: type }
    #features = [features_element]
    #requests_element = { image: image, features: features }
    #requests = [requests_element]
    #@response = image_annotator_client.batch_annotate_images(requests)

    response = @post.face_detection_response
    @debug = nil

    if response.nil?

      require "google/cloud/vision"

      image_annotator_client = Google::Cloud::Vision::ImageAnnotator.new(version: :v1)

      cached = ""

      #we should try pass this a google cloud storage URL instead
      response_obj = image_annotator_client.face_detection image: url_for(@post.picture.variant(auto_orient: true).processed.service_url)

      face_annotations = []

      if response_obj.responses.first.error.nil?
        response_obj.responses.first.face_annotations.each do |face_annotation|
          face_annotations.push({
            roll_angle: face_annotation.roll_angle,
            pan_angle: face_annotation.pan_angle,
            tilt_angle: face_annotation.tilt_angle,
            detection_confidence: face_annotation.detection_confidence,
            landmarking_confidence: face_annotation.landmarking_confidence,
            joy_likelihood: face_annotation.joy_likelihood,
            sorrow_likelihood: face_annotation.sorrow_likelihood,
            anger_likelihood: face_annotation.anger_likelihood,
            surprise_likelihood: face_annotation.surprise_likelihood,
            under_exposed_likelihood: face_annotation.under_exposed_likelihood,
            blurred_likelihood: face_annotation.blurred_likelihood,
            headwear_likelihood: face_annotation.headwear_likelihood
          })
        end

        @post.update(face_detection_response: face_annotations.to_json)
      end
      
      face_annotations_to_read = JSON.parse(face_annotations.to_json)

      #if its empty we want to know why
      unless face_annotations_to_read.present?
        @debug = response_obj
      end
    else
      cached = "Cached: "
      face_annotations_to_read = JSON.parse(response)
    end

    if face_annotations_to_read.present?
      @response = "<!-- #{cached} -->#{face_annotations_to_read.first["headwear_likelihood"]} you're wearing a hat"
    else
      @response = "<!-- #{cached} -->Look at the camera, would you?"
    end

  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :picture, uploads: [])
    end
end
