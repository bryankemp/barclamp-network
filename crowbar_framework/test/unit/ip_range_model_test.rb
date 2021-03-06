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
 

class IpRangeModelTest < ActiveSupport::TestCase

  # Test successful creation
  test "IpRange creation: success" do
    create_an_ip_range()
  end


  # Test creation failure due to missing name
  test "IpRange creation: failure due to missing name" do
    assert_raise ActiveRecord::RecordInvalid do
      ip_range = IpRange.new()

      ip = IpAddress.new( :cidr => "192.168.24.23/24" )
      ip_range.start_address = ip

      ip = IpAddress.new( :cidr => "192.168.24.99/24" )
      ip_range.end_address = ip

      ip_range.save!
    end
  end


  # Test creation failure due to missing start_address
  test "IpRange creation: failure due to start address" do
    assert_raise ActiveRecord::RecordInvalid do
      ip_range = IpRange.new( :name => "dhcp" )

      ip = IpAddress.new( :cidr => "192.168.24.99/24" )
      ip_range.end_address = ip

      ip_range.save!
    end
  end


  # Test creation failure due to missing end_address
  test "IpRange creation: failure due to end address" do
    assert_raise ActiveRecord::RecordInvalid do
      ip_range = IpRange.new( :name => "dhcp" )

      ip = IpAddress.new( :cidr => "192.168.24.99/24" )
      ip_range.start_address = ip

      ip_range.save!
    end
  end


  # Test delete cascade to start & end addresses
  test "IpRange deletion: casaded delete test" do
    ip_range = create_an_ip_range()

    ip_range_id = ip_range.id
    ip_range.destroy()

    ip_ranges = IpAddress.where( :start_ip_range_id => ip_range_id )
    assert 0, ip_ranges.size

    ip_ranges = IpAddress.where( :end_ip_range_id => ip_range_id )
    assert 0, ip_ranges.size
  end


  private
  # Create an IpRange
  def create_an_ip_range
    ip_range = IpRange.new( :name => "dhcp" )

    ip = IpAddress.new( :cidr => "192.168.24.50/24" )
    ip_range.start_address = ip

    ip = IpAddress.new( :cidr => "192.168.24.99/24" )
    ip_range.end_address = ip

    ip_range.save!
    assert_not_nil ip_range
    ip_range
  end
end
