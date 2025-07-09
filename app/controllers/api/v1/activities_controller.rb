class Api::V1::ActivitiesController < ApplicationController
  include ActivitiesConcern

  skip_before_action :authenticate_user!, only: [ :index, :show ]

  before_action :set_activity, only: [ :show, :update, :destroy, :join, :leave ]
  before_action -> { authorize_user!(@activity.creator) }, only: [ :update, :destroy ]

  rescue_from ArgumentError, with: :handle_invalid_filtering

  def index
    cache_key = "activities/#{params.to_unsafe_h.hash}"
    activities = Rails.cache.fetch(cache_key, expires_in: 1.minute) { gather_activities(params) }

    render status: :ok, json: activities, each_serializer: ActivitySerializer
  end

  def show
    render status: :ok, json: @activity, serializer: ActivityDetailSerializer
  end

  def create
    ActiveRecord::Base.transaction do
      @activity = Activity.create!(activity_params.merge(user_id: current_user.id))

      @activity.participant_records.create!(user: current_user)
    end

    render status: :created, json: @activity
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    if @activity.update(activity_params)
      render status: :ok, json: @activity
    else
      render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages }
    end
  end

  def destroy
    if @activity.participants.destroy_all
      if @activity.destroy
        render status: :no_content
      else
        render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages, source: "activity" }
      end
    else
      render status: :unprocessable_entity, json: { errors: "Failed to delete participants", source: "participants" }
    end
  end

  def join
    participant = @activity.participant_records.build(user: current_user)

    if participant.save
      render status: :created, json: "User joined the activity"
    else
      render status: :unprocessable_entity, json: { errors: participant.errors.full_messages }
    end
  rescue ActiveRecord::RecordNotUnique
    render status: :conflict, json: { error: "User already participates in this activity" }
  end

  def leave
    participant = @activity.participants.find_by(user_id: current_user.id)

    if participant.nil?
      render status: :not_found, json: { error: "You are not a participant in this activity" }
    elsif participant.destroy
      render status: :ok, json: { message: "You left the activity" }
    else
      render status: :unprocessable_entity, json: { error: participant.errors.full_messages }
    end
  end

  def generate_description
    title = params[:title]
    location = params[:location]
    start_time = params[:start_time]

    if start_time.present?
      begin
        parsed_time = Time.parse(start_time)
        formatted_time = parsed_time.strftime("%Y-%m-%d %H:%M")
      rescue ArgumentError
        formatted_time = nil
      end
    end

    prompt = "Here is the activity information:"
              - Title: #{title}
              - Location: #{location}
              - Start time: #{start_time}

              Please write a short, warm, and appealing description (2-3 sentences) that encourages people to join, mentioning the location
              and the upcoming start time in a natural way. The tone should be welcoming, positive, and inclusive, suitable for a community of
              people looking to make friends by participating in activities together.

              Example output:
              \"Join us for #{title} happening at #{location} on #{start_time}! It's a great opportunity to meet new friends and have a fantastic
               time together.Don't miss out on this fun and welcoming event!\"

              Please generate the description in the language the context is provided in. Only keep the generated description in the text."

    response = HTTParty.post("https://api.groq.com/openai/v1/chat/completions",
      headers: {
        "Authorization" => "Bearer #{ENV['GROQ_API_KEY']}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "meta-llama/llama-4-scout-17b-16e-instruct",
        messages: [
          { role: "system", content: "You are a creative and friendly assistant who writes engaging and inviting descriptions for social activities." },
          { role: "user", content: prompt }
        ],
        temperature: 0.7
      }.to_json
    )

    puts response

    if response.ok?
      description = response.parsed_response["choices"].first["message"]["content"]
      render json: { description: description.strip }
    else
      Rails.logger.error("OpenAI API error: #{response.body}")
      render status: :bad_request, json: { errors: "Failed to generate description" }
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { error: "Activity not found" }
  end

  def activity_params
    params.permit(permitted_activity_attributes)
  end

  def permitted_activity_attributes
    [ :title, :description, :location, :start_time, :max_participants, :minimum_age, :maximum_age ]
  end

  def handle_invalid_filtering(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
