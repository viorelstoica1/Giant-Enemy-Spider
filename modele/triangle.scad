// Creates a 2D triangle with the given sides and/or angles.
// Any three parameters can be used to describe the triangle, e.g.
// a=3,b=4,c=5; a=3,b=4,c_angle=90; and a=3,b_angle=53.13,c_angle=90
// all describe the same triangle.
// Side c runs along the x axis, with side a leaving the origin at a_angle.
// Reference: https://www.calculator.net/triangle-calculator.html
module triangle(a=0,b=0,c=0,a_angle=0,b_angle=0,c_angle=0) {
    assert(a_angle==a_angle && b_angle==b_angle && c_angle==c_angle,
           "Invalid triangle: impossible angles");
        
    // returns c
    function shared_angle(a, b, c_angle) = sqrt(pow(b,2)+pow(a,2)-2*b*a*cos(c_angle));

    // returns c_angle
    function opposing_angle(a, a_angle, b) = asin(b*sin(a_angle)/a);

    // returns angles A, B, C if they sum to 180
    // if one angle is unset (0) it will be set to the difference of the other two
    function triangle_angles(a, b, c) =
      let (
        a = a > 0 ? a : assert(b!=0 && c!=0, "Insufficient angles") 180 - b - c,
        b = b > 0 ? b : assert(a!=0 && c!=0, "Insufficient angles") 180 - a - c,
        c = c > 0 ? c : assert(a!=0 && b!=0, "Insufficient angles") 180 - a - b
      )
      assert(a + b + c == 180, "Invalid triangle: impossible angles")
      [a,b,c];

    // returns b
    function angle_ratio(a, angle_a, angle_b) = a*sin(angle_b)/sin(angle_a);

    // Three Sides
    if (a>0 && b>0 && c>0) {
        assert(a_angle==0 && b_angle==0 && c_angle==0, "Too many arguments");
        let ( a_angle = acos((pow(b,2)+pow(c,2)-pow(a,2))/(2*b*c)) ) {
            assert(a_angle==a_angle, "Invalid triangle: impossible lengths");
            assert(sin(a_angle)!= 0, "Invalid triangle: colinear");
            polygon(points = [[0, 0], [c, 0], [b * cos(a_angle), b * sin(a_angle)]]);
        }
    // Shared Angle
    } else if (a>0 && b>0 && c_angle>0) {
        assert(c==0 && a_angle==0 && b_angle==0, "Too many arguments");
        triangle(a,b,shared_angle(a,b,c_angle));
    } else if (a>0 && c>0 && b_angle>0) {
        assert(b==0 && a_angle==0 && c_angle==0, "Too many arguments");
        triangle(a,shared_angle(a,c,b_angle),c);
    } else if (b>0 && c>0 && a_angle>0) {
        assert(a==0 && b_angle==0 && c_angle==0, "Too many arguments");
        triangle(shared_angle(b,c,a_angle),b,c);
    // Opposing Angle
    } else if (a>0 && a_angle>0 && b>0) {
        assert(c==0 && c_angle==0 && b_angle==0, "Too many arguments");
        triangle(a=a,b=b,c_angle=opposing_angle(a,a_angle,b));
    } else if (a>0 && a_angle>0 && c>0) {
        assert(b==0 && b_angle==0 && c_angle==0, "Too many arguments");
        triangle(a=a,c=c,b_angle=opposing_angle(a,a_angle,c));
    } else if (b>0 && b_angle>0 && a>0) {
        assert(c==0 && c_angle==0 && a_angle==0, "Too many arguments");
        triangle(a=a,b=b,c_angle=opposing_angle(b,b_angle,a));
    } else if (b>0 && b_angle>0 && c>0) {
        assert(a==0 && a_angle==0 && c_angle==0, "Too many arguments");
        triangle(a=a,c=c,a_angle=opposing_angle(b,b_angle,c));
    } else if (c>0 && c_angle>0 && a>0) {
        assert(b==0 && b_angle==0 && a_angle==0, "Too many arguments");
        triangle(a=a,c=c,b_angle=opposing_angle(c,c_angle,a));
    } else if (c>0 && c_angle>0 && b>0) {
        assert(a == 0 && a_angle == 0 && b_angle == 0, "Too many arguments");
        triangle(b = b, c = c, a_angle = opposing_angle(c, c_angle, b));
    // Two+ Angles
    } else if (a>0 && b==0 && c==0) {
        angles = triangle_angles(a_angle, b_angle, c_angle);
        triangle(a=a, b=angle_ratio(a,angles[0],angles[1]), c=angle_ratio(a,angles[0],angles[2]));
    } else if (b>0 && a==0 && c==0) {
        angles = triangle_angles(a_angle, b_angle, c_angle);
        triangle(a=angle_ratio(b,angles[1],angles[0]), b=b, c=angle_ratio(b,angles[1],angles[2]));
    } else if (c>0 && a==0 && b==0) {
        angles = triangle_angles(a_angle, b_angle, c_angle);
        triangle(a=angle_ratio(c,angles[2],angles[0]), b=angle_ratio(c,angles[2],angles[1]), c=c);
    } else {
        assert(false, "Insufficient arguments");
    }
}