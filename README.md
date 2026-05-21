# iOSApp1 - Tim Hortons Ordering App Prototype

First assignment project for iOS Development.

This repository contains a SwiftUI prototype app for tracking daily Tim Hortons team orders.

## Core Features Implemented

- Add a team member and their Tim Hortons order
- Store and display all orders for the day
- Mark/unmark reusable favorite orders
- Persist orders locally with JSON storage
- Coffee run countdown timer (creative variation)

## Source Structure

- `TimHortonsRun/Models`: app data models (`Order`, `TeamOrder`)
- `TimHortonsRun/ViewModels`: app state and timer logic (`OrderListViewModel`)
- `TimHortonsRun/Views`: SwiftUI UI components
- `TimHortonsRun/Services`: local persistence (`OrderStore`)

## Notes

- The code is intentionally commented around non-obvious logic to support coursework readability.
- Open this folder in Xcode and create/attach an iOS App target named `TimHortonsRun` if your local machine requires target/project generation via Xcode UI.
