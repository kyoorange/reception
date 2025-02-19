import React, { useState } from "react";

const SearchBox = ({ onSearchResult }) => {
    const [query, setQuery] = useState("");
    const [result, setResult] = useState("");

    const handleInputChange = (event) => {
        setQuery(event.target.value);
    };

    const handleKeyPress = (event) => {
        if (event.key === "Enter") {
            fetchRegistrantName();
        }
    };

    const fetchRegistrantName = async () => {
        try {
            const response = await fetch(`/registrants/${query}`);
            if (response.ok) {
                const data = await response.json();
                setResult(data.name || "該当する登録者が見つかりません");
                onSearchResult(data); // 見つかった会員情報をRoomModalに渡す
            } else {
                setResult("該当する登録者が見つかりません");
                onSearchResult(null);
            }
        } catch (error) {
            console.error("Error fetching registrant:", error);
            setResult("エラーが発生しました");
            onSearchResult(null);
        }
    };

    return (
        <div>
            <input
                type="text"
                placeholder="会員番号を入力..."
                value={query}
                onChange={handleInputChange}
                onKeyDown={handleKeyPress}
            />
            {result && <p>結果: {result}</p>}
        </div>
    );
};

export default SearchBox;
