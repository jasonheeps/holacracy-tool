const positionOrgChart = () => {
  // define a radius for all elements
  const elements = document.querySelectorAll('.circle-0,.subcircle, .role');
  elements.forEach(e => e.r = e.getBoundingClientRect().width/2);

  // define center of gcc
  const GCC = document.querySelector('.circle-0');
  const GCCRect = GCC.getBoundingClientRect();
  GCC.center = {
    x: GCCRect.width/2,
    y: GCCRect.height/2
  };

  // NOW FOR TESTING THE ALG:
  const children = document.querySelectorAll('.circle-1, .role-0');
  const childrenArray = Array.from(children);
  positionChildren(GCC, GCC, childrenArray);
};

// *******************
// ** THE ALGORITHM **
// *******************

// attributes we need for a circle:
// -x and y, only for the parent circle --> gets defined in the algorithm (except for GCC which I defined above)
// - .style.bottom, only for the pc /*its lowest x coordinate*/ --> gets defined in the algorithm (except for GCC, and there I have a fallback)
// -r /*radius*/

// this algorithm runs for each circle, starting with the GCC

// given:
// - GCC
// - pc (parent circle, js object),
// - children (all direct subcircles and roles, js objects)

function positionChildren(GCC, pc, children) {
  if (children.length === 0) {
    console.log('children.length is zero!');
    return;
  }
  // position the first child at the bottom of its parent circle
  const firstChild = children[0];
  firstChild.bottom = (pc === GCC ? 0 : pc.bottom);
  firstChild.style.bottom = `${firstChild.bottom}px`; /* pc.style.bottom = lowest x coordinate of pc; GCC.*/
  firstChild.left = (pc.center.x - firstChild.r);
  firstChild.style.left = `${firstChild.left}px`;
  firstChild.center = {x: pc.center.x, y: firstChild.bottom + firstChild.r};

  // CONSOLE LOG FOR TESTING
  // console.log('first child has been positioned:');
  // console.log('x:' + firstChild.center.x);
  // console.log('y:' + firstChild.center.y);

  const placedChildren = [firstChild];
  const remainingChildren = children.slice(1);

  // find a position (center) for all remaining children
  remainingChildren.forEach(c => {
    let newCenter = {};
    // define a circle around the center of pc
    const e = {
      r: pc.r - c.r,
      center: {
        x: pc.center.x,
        y: pc.center.y
      }
    };

    // define circles around the centers of all placed children
    const distanceKeepers = [];
    placedChildren.forEach(placed => {
      let dk = {
        r: placed.r + c.r,
        center: {
          x: placed.center.x,
          y: placed.center.y
        }
      };
      distanceKeepers.push(dk);
    });

    distanceKeepers.unshift(e);

    // CONSOLE LOG FOR TESTING
    // console.log('distanceKeepers have been defined:');
    // console.log(distanceKeepers);

    // iterate over every pair of distance keeper circles
    // in order to find the lowest valid center point for children c
    distanceKeepers.forEach(c1 => {
      distanceKeepers.forEach(c2 => {
        if (c1 === c2) {
          return;
        }
        // calculate the intersections points (there are 0, 1, or 2)
        const intersections = calcIntersections([
          {x: c1.center.x, y: c1.center.y, r: c1.r},
          {x: c2.center.x ,y: c2.center.y ,r: c2.r}
        ]);

        // CONSOLE LOG FOR TESTING
        // console.log('found intersections:');
        // console.log(intersections[0]);
        // console.log(intersections[1]);

        // continue if there are no intersections
        if (!intersections) {
          return;
        }

        // check if there is a new optimal (lowest) intersection
        intersections.forEach(i => {
          // CONSOLE LOG FOR TESTING
          // console.log('there are intersections!');
          const isLower = (newCenter.y ? i.y > newCenter.y : true)
          if (isLower &&
            valid({
              newIntersection: i,
              x: pc.center.x,
              y: pc.center.y,
              r: pc.r
            })) {
            newCenter = i;
          }
        }); /* end of 'intersections.forEach' */
      }); /* end of 'distanceKeepers.forEach' inner loop*/
    }); /* end of 'distanceKeepers.forEach' outer loop*/

    // set the new center
    c.style.bottom = newCenter.x - c.height/2;
    c.style.left = newCenter.y - c.width/2;
    c.center = newCenter;
    placedChildren.push(c);
  }); /* end of 'remainingChildren.forEach' */
}

// checks if the intersection is within the boundaries of the circle
function valid(params) {
  const ix = params.newIntersection.x;
  const iy = params.newIntersection.y;
  const x = params.x;
  const y = params.y;
  const r = params.r;

  const dx = ix - x;
  const dy = iy - y;
  const d = Math.sqrt((dy*dy) + (dx*dx));

  return (d > r ? false: true);
}

function calcIntersections(params) {
  const x0 = params[0].x;
  const y0 = params[0].y;
  const r0 = params[0].r;
  const x1 = params[1].x;
  const y1 = params[1].y;
  const r1 = params[1].r;

  let a, dx, dy, d, h, rx, ry;
  let x2, y2;

  /* dx and dy are the vertical and horizontal distances between
   * the circle centers.
   */
  dx = x1 - x0;
  dy = y1 - y0;

  /* Determine the straight-line distance between the centers. */
  d = Math.sqrt((dy*dy) + (dx*dx));

  /* Check for solvability. */
  if (d > (r0 + r1)) {
      /* no solution. circles do not intersect. */
      return false;
  }
  if (d < Math.abs(r0 - r1)) {
      /* no solution. one circle is contained in the other */
      return false;
  }

  /* 'point 2' is the point where the line through the circle
   * intersection points crosses the line between the circle
   * centers.
   */

  /* Determine the distance from point 0 to point 2. */
  a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d) ;

  /* Determine the coordinates of point 2. */
  x2 = x0 + (dx * a/d);
  y2 = y0 + (dy * a/d);

  /* Determine the distance from point 2 to either of the
   * intersection points.
   */
  h = Math.sqrt((r0*r0) - (a*a));

  /* Now determine the offsets of the intersection points from
   * point 2.
   */
  rx = -dy * (h/d);
  ry = dx * (h/d);

  /* Determine the absolute intersection points. */
  const xi = x2 + rx;
  const xi_prime = x2 - rx;
  const yi = y2 + ry;
  const yi_prime = y2 - ry;

  // return [xi, xi_prime, yi, yi_prime];
  return [{x: xi, y: yi}, {x: xi_prime, y: yi_prime}];
}

export { positionOrgChart };
