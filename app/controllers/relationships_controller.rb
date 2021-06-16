class RelationshipsController < ApplicationController
  def create
    #申請または承認するユーザーを取得
    @user = User.find_by(public_uid: params[:follow_id])
    #取得したユーザーに申請または承認
    current_user.follow(@user)
    @friend = current_user.followings & current_user.followers
    @RequestUser = current_user.followings.where.not(id: current_user.followers.ids)
    @ApprovalUser = current_user.followers.where.not(id: current_user.followings.ids)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    #送られてきたリレーション取得
    relation = Relationship.find(params[:id])
    #それぞれのユーザー取得
    @user = relation.follow
    @approval_user = relation.user
    #もし@userがcurrent_userのフレンドかつ@approval_userがcurrent_userの場合(フレンド解除)
    if current_user.friend?(@user) && current_user == @approval_user
      current_user.unfollow(@user)
      @user.unfollow(current_user)
      #もし@userに対してcurrent_userが申請中かつ@approval_userがcurrent_userの場合(申請解除)
    elsif current_user.request?(@user) && current_user == @approval_user
      current_user.unfollow(@user)
      #もし@approval_userがcurrent_userに申請してきている場合かつ@userがcurrent_userの場合(申請拒否)
    elsif current_user.approval?(@approval_user) && current_user == @user
      @approval_user.unfollow(current_user)
    else
      redirect_to root_path
    end
    @friend = current_user.followings & current_user.followers
    @RequestUser = current_user.followings.where.not(id: current_user.followers.ids)
    @ApprovalUser = current_user.followers.where.not(id: current_user.followings.ids)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
end
