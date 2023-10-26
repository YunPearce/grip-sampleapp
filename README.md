# %Grip Integration

## Summary

%grip is a wrapper library that integrates with the Pharos agent to facilitate easy feedback submission by end users. Once an app integrates %grip, end users can fill out and submit forms for feedback. Upon submitting the feedback, the data is posted to the Pharos agent location determined by the %grip configuration. In addition to user-submitted tickets, %grip also supports auto-generating tickets via a client application’s ++on-fail arm.

## %grip Configuration

1. Configuring %grip is similar to using the dbug agent. Wrap your agent at the start of your agent file in `agent:grip`, right above `dbug` (if you use it).

```hoon
%-  %-  agent:grip
  :*
  ~zod           :: @p of a ship/star etc. where you'll have your %pharos app installed
  *app-version   :: curent version of the app
  /apps/app      :: path where your app located or rather where you would set up your button, this path will be used to host %grip page/form and on submiting form user will be rerdirected back to current path
  ==
```

2. %grip includes a page for feedback submission. This makes it easy for a developer to integrate a page for collecting user feedback.

-In your agent application, configure the necessary UI elements to direct the end user to the page for form submission. An example would be a button or a-tag. This is the front-end element that redirects users to the %grip submission form fronted that will be hosted at `<path>/report`.

3. **Form submission**: Once configured, users have the capability to provide feedback directly in the %grip form. The following fields are available:

   - A checkbox through which a user can anonymize/de-anonymize.
   - A drop-down selection for request type which currently includes feature requests, support requests, bug reports, documentation requests, and general requests.
   - A title field for issue summary and a body field for issue details.

4. In the %grip form, “Settings” can also be configured. Currently, the only setting is the ability to enable/disable auto-generating tickets for submission to Pharos when the on-fail arm is called.

5. Auto-generated ++on-fail reporting is available through gripe. This can be enabled by the end user in the %grip settings. If enabled, %grip will attempt to send information to the respective Pharos agent when the on-fail arm is called. Auto-generated tickets will attempt to send +vats and an error trace.

## Testing %grip & On-Fail Logic

Testing %grip is possible using the included sample application. This sample app can be configured to communicate to an installed %pharos agent for testing. To install,

```hoon
|new-desk %grip
|mount %grip
```

Then copy the contents of the app to your ship's %grip desk. 

Next you will need to modify the @p of the parent ship/star where the %pharos app is installed. In the sample, this is contained on line 16 of the `app.hoon` file. For example, if you are running %pharos on a fakezod named ~zod:

```hoon
...
  ~zod           :: @p of a ship/star etc. where you'll have your %pharos app installed
...
```

```hoon
|commit %grip
|install our %grip
```

%grip will now be avaialble in landscape with a sample UI. In the sample UI, click the "Help" button to launch the %grip submission form.

Testing the on-fail logic is possible using the included sample applciation. First, enable auto-generated ticket submission within the %grip form. Then, from dojo, call

```hoon
:app %timer ::will start timer for 10seconds and crash app after, sending ticket with vats and error trace
```
