1. Fade In Transition (Login Page)
   I added a smooth entrance effect for the login form so it doesn't just pop in instantly.
   • Animation type: Explicit Animation
   • Reference: https://api.flutter.dev/flutter/widgets/FadeTransition-class.html
   • How it works: It uses an AnimationController to gradually change the opacity from 0.0 to 1.0.

2. Custom Page Transitions (Navigation)
   I customized the route changes in GoRouter to move away from standard platform transitions.
   • Animation type: Explicit Animation (Page Route)
   • Reference: https://api.flutter.dev/flutter/widgets/SlideTransition-class.html
   • How it works: When switching between the Login and Home screens, the new page slides up slightly while fading in.

3. Smart Budget Counter & Progress Bar (Dashboard)
   I made the spending amount and progress bar "live" by animating their values whenever they load or change.
   • Animation type: Implicit Animation
   • Reference: https://api.flutter.dev/flutter/widgets/TweenAnimationBuilder-class.html
   • How it works: It interpolates between values, making the numbers "count up" and the progress bar "fill" smoothly.

4. Elastic Category Scale (Dashboard)
   I added a staggered "pop-up" effect for the category cards (Flights, Hotels, etc.) to give the dashboard some energy.
   • Animation type: Implicit Animation (with Custom Curve)
   • Reference: https://api.flutter.dev/flutter/animation/Curves/elasticOut-constant.html
   • How it works: Each card scales up with a springy effect using Curves.elasticOut, triggered with a slight delay.

5. Pulse Animation (Review Plan Button)
   I added a "breathing" effect to the Floating Action Button to draw the user's attention when they have items in their plan.
   • Animation type: Explicit Animation (Repeated)
   • Reference: https://api.flutter.dev/flutter/animation/AnimationController/repeat.html
   • How it works: I set the controller to repeat(reverse: true), which makes the button pulse in and out continuously using ScaleTransition.