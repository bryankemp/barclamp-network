# Copyright 2012, Dell 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 

require 'test_helper'
 
class RouterModelTest < ActiveSupport::TestCase

  # Test successful creation
  test "Router creation: success" do
    assert_not_nil create_a_router()
  end


  # Test validation: creation failed due to no ip
  test "Router creation: failure due to no ip" do
    assert_raise ActiveRecord::RecordInvalid do
      Router.create!( :pref => 5 )
    end
  end


  # Test validation: creation failed due to no pref
  test "Router creation: failure due to no pref" do
    assert_raise ActiveRecord::RecordInvalid do
      ip = IpAddress.new(:cidr => "192.168.130.12")
      router = Router.new()
      router.ip = ip
      router.save!()
    end
  end


  # Test validation: creation failed due to alpha pref
  test "Router creation: failure due to alpha pref" do
    assert_raise ActiveRecord::RecordInvalid do
      ip = IpAddress.new(:cidr => "192.168.130.12")
      router = Router.new()
      router.pref = "asdf"
      router.ip = ip
      router.save!()
    end
  end


  # Test cascade ip deletion on router deletion
  test "Router deletion: cascade delete to ip" do
    router = create_a_router()
    ip_id = router.ip.id
    router.destroy()

    ips = IpAddress.where( :id => ip_id )
    assert_equal 0, ips.size
  end


  private
  # Create a Router
  def create_a_router()
    ip = IpAddress.new(:cidr => "192.168.130.12")
    router = Router.new()
    router.pref = 5
    router.ip = ip
    router.save!()
    router
  end
end
