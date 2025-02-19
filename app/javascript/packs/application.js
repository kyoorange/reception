import React from 'react';
import ReactDOM from 'react-dom/client';
import SearchBox from '../components/SearchBox';
import RegistrantList from '../components/RegistrantList';
import App from "../components/App";
import ReactRailsUJS from 'react_ujs';

// コンポーネントを自動的に検出し、Rails側で呼び出せるように設定
const componentRequireContext = require.context("components", true);
ReactRailsUJS.useContext(componentRequireContext);

document.addEventListener('DOMContentLoaded', () => {
    // SearchBoxのマウントポイント
    const searchBoxNode = document.getElementById('search-box');
    if (searchBoxNode) {
        const root = ReactDOM.createRoot(searchBoxNode);
        root.render(<SearchBox />);
    }

    // RegistrantListのマウントポイント
    const registrantListNode = document.getElementById('registrant-list');
    if (registrantListNode) {
        const registrants = JSON.parse(registrantListNode.getAttribute('data-registrants'));
        const root = ReactDOM.createRoot(registrantListNode);
        root.render(<RegistrantList registrants={registrants} />);
    }

    // Appコンポーネントのマウントポイント
    const appNode = document.getElementById('react-app');
    if (appNode) {
        const root = ReactDOM.createRoot(appNode);
        root.render(<App />);
    }
});
