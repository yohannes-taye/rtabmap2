<launch>
  <group ns="rtabmap">

    <!-- Use RGBD synchronization -->
    <!-- Here is a general example using a standalone nodelet, 
         but it is recommended to attach this nodelet to nodelet 
         manager of the camera to avoid topic serialization -->
    <node pkg="nodelet" type="nodelet" name="rgbd_sync" args="standalone rtabmap_ros/rgbd_sync" output="screen">
      <remap from="rgb/image"       to="/kinect2/qhd/image_color_rect"/>
      <remap from="depth/image"     to="/kinect2/qhd/image_depth_rect"/>
      <remap from="rgb/camera_info" to="/kinect2/qhd/camera_info"/>
      <remap from="rgbd_image"      to="rgbd_image"/> <!-- output -->
      
      <!-- Should be true for not synchronized camera topics 
           (e.g., false for kinectv2, zed, realsense, true for xtion, kinect360)-->
      <param name="approx_sync"       value="false"/> 
    </node>

    <node name="rtabmap" pkg="rtabmap_ros" type="rtabmap" output="screen" args="--delete_db_on_start">
          <param name="frame_id" type="string" value="base_link"/>

          <param name="subscribe_depth" type="bool" value="false"/>
          <param name="subscribe_rgbd" type="bool" value="true"/>
          <param name="subscribe_scan" type="bool" value="true"/>

          <remap from="odom" to="/odom"/>
          <remap from="scan" to="/scan"/>
          <remap from="rgbd_image" to="rgbd_image"/>

          <param name="queue_size" type="int" value="10"/>

          <!-- RTAB-Map's parameters -->
          <param name="RGBD/NeighborLinkRefining" type="string" value="true"/>
          <param name="RGBD/ProximityBySpace"     type="string" value="true"/>
          <param name="RGBD/AngularUpdate"        type="string" value="0.01"/>
          <param name="RGBD/LinearUpdate"         type="string" value="0.01"/>
          <param name="RGBD/OptimizeFromGraphEnd" type="string" value="false"/>
          <param name="Grid/FromDepth"            type="string" value="false"/> <!-- occupancy grid from lidar -->
          <param name="Reg/Force3DoF"             type="string" value="true"/>
          <param name="Reg/Strategy"              type="string" value="1"/> <!-- 1=ICP -->
          
          <!-- ICP parameters -->
          <param name="Icp/VoxelSize"                 type="string" value="0.05"/>
          <param name="Icp/MaxCorrespondenceDistance" type="string" value="0.1"/>
    </node>
  </group>
</launch>
