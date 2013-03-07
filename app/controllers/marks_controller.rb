class MarksController < ApplicationController
  before_filter :authenticate_user!

  # GET /marks
  # GET /marks.json
  def index
    @marks = Mark.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @marks }
    end
  end

  # GET /marks/1
  # GET /marks/1.json
  def show
    @mark = Mark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mark }
    end
  end

  # GET /:profile_id/kartor/:map_id/markeringar/ny
  # GET /marks/new.json
  def new
    # Hämtar användaren som äger kartan för att filtrera
    @user = User.find(params[:profile_id])

    # Hämtar rätt karta från användarens samling
    @map = @user.maps.find(params[:map_id])

    # Kontrollerar att användaren är kartans ägare
    if @map.user == current_user
      @mark = Mark.new do |m|
        m.map = @map
        m.location = @map.location
      end
      display_map(@map)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @mark }
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # GET /:profile_id/kartor/:map_id/markeringar/:id/redigera
  def edit
    @mark = Mark.find(params[:id])
    @map = @mark.map

    # Kollar så att användaren är ägare till markeringen eller kartan
    if @mark.user == current_user or @map.user == current_user
      display_map(@map)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @mark }
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # POST /:profile_id/kartor/:map_id/markeringar
  # POST /marks.json
  def create
    # Tar bort IDt från en tidigare sparad location (om valideringen failats)
    # Tar man bort denna rad kastas undantag för det inte går att assiciera en
    # redan befintlig location med ett objekt som inte än är skapad (kartan)
    params[:mark][:location_attributes][:id] = nil

    # Hämtar användaren som äger kartan för att filtrera
    @user = User.find(params[:profile_id])

    # Hämtar rätt karta från användarens samling
    @map = @user.maps.find(params[:map_id])

    # kontrollerar att användaren är ägare till kartan
    if @map.user == current_user
      @mark = Mark.new(params[:mark]) do |m|
        m.map = @map
        m.user = current_user
        m.location = Location.find_by_latitude_and_longitude(m.latitude, m.longitude) || m.location
      end

      display_map(@map)
      # Kontrollerar så det inte redan finns en markering med samma position på kartan
      unless @mark.exists_in_map?
        respond_to do |format|
          if @mark.save
            format.html {
              flash[:success] = t :created, mark: @mark.name, scope: [:marks]
              redirect_to profile_map_path(@map.user.slug, @map.slug)
            }
            format.json { render json: @mark, status: :created, location: @mark.map }
          else
            format.html {
              flash[:error] = t :failed_to_create, scope: [:marks]
              render action: :new
            }
            format.json { render json: @mark.errors, status: :unprocessable_entity }
          end
        end
      else
        flash[:error] = t :mark_exists_in_map, scope: [:marks]
        render action: :new
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # PUT /markeringar/:id
  # PUT /marks/id.json
  def update
    @mark = Mark.find(params[:id])
    @map = @mark.map

    # Kollar så att användaren är ägare till markeringen eller kartan
    if @mark.user == current_user or @map.user == current_user

      # Kontrollerar så det inte redan finns en markering med samma position på kartan
      unless @mark.exists_in_map?
        respond_to do |format|
          if @mark.update_attributes(params[:mark])
            format.html {
              flash[:success] = t :updated, mark: @mark.name, scope: [:marks]
              redirect_to profile_map_path(@map.user.slug, @map.slug)
            }
            format.json { head :no_content }
          else
            format.html {
              flash[:error] = t :failed_to_update, scope: [:marks]
              display_map(@mark.map)
              render action: :edit }
            format.json { render json: @mark.errors, status: :unprocessable_entity }
          end
        end
      else
        flash[:error] = t :mark_exists_in_map, scope: [:marks]
        render action: :edit
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # DELETE /markeringar/:id
  # DELETE /marks/:id.json
  def destroy
    @mark = Mark.find(params[:id])
    @map = @mark.map

    # Kollar så att användaren är ägare till markeringen eller kartan
    if @mark.user == current_user or @map.user == current_user
      respond_to do |format|
        if @mark.destroy
          format.html {
            flash[:success] = t :removed, mark: @mark.name, scope: [:marks]
          }
          format.json { head :no_content }
        else
          format.html {
            flash[:error] = t :failed_to_remove, scope: [:marks]
          }
          format.json { render json: @mark.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = t :access_denied
    end
  end

  # Sets options for map
  def display_map(map)

    @display_map = {
        map_options: {
            auto_zoom: false,
            type: map.map_type,
            zoom: map.zoom,
            center_latitude: map.latitude,
            center_longitude: map.longitude,
            raw: "{ scrollwheel: false }"
        },
        markers: {
            data: map.marks.to_gmaps4rails  do |mark, marker|

              # Rendera en partial vy i infofönstret
              marker.infowindow(render_to_string(partial: "marks/foobar", locals: { mark: mark}))

              # ändra markeringens bild
              marker.picture({
                                 picture: "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/32/Map-Marker-Bubble-Chartreuse-icon.png",
                                 width: 32,
                                 height: 32
                             })
              # Titeln
              marker.title(mark.name)
              # Sidebar - inte implementerat
              ##marker.sidebar "i'm the sidebar"
              ## Om man vill lägga till fler fält till markeringen i jsonformat
              marker.json({ id: mark.id, foo: "bar" })
            end
        }
    }
  end
end
