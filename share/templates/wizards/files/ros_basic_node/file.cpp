#include <ros/ros.h>

// Mor information at http://wiki.ros.org/ROS/Tutorials/UnderstandingNodes

int main(int argc, char **argv)
{
  ros::init(argc, argv, "%{BaseName}");
  ros::NodeHandle nh;

  ROS_INFO("Hello world!");
}
