import React, { useState, useEffect } from "react";

const RoomModal = ({ roomNumber, onClose, onStatusChange }) => {
    const [registrantQuery, setRegistrantQuery] = useState("");
    const [registrantName, setRegistrantName] = useState("");
    const [registrantNumber, setRegistrantNumber] = useState("");
    const [occupyId, setOccupyId] = useState(null);
    const [createdAt, setCreatedAt] = useState("");
    const [rotation, setRotation] = useState(0);
    const [statusChanged, setStatusChanged] = useState(false);

    const LIMIT_IN_SECONDS = 2 * 60 * 60;

    // 利用中のエフェクト - 初回のみデータを取得し、その後は時計の更新のみを行う
    useEffect(() => {
        // 初回のみデータを取得
        fetchOccupyData();

        // 時計の更新処理
        if (createdAt) {
            const interval = setInterval(() => {
                const elapsedSeconds = (new Date() - new Date(createdAt)) / 1000;
                const rotationDegree = Math.min(360, (elapsedSeconds / LIMIT_IN_SECONDS) * 360);
                setRotation(rotationDegree);
            }, 1000);
            return () => clearInterval(interval); // コンポーネントのクリーンアップ
        }
    }, [createdAt]);

    const fetchOccupyData = async () => {
        try {
            const paddedRoomNumber = String(roomNumber).padStart(6, '0');
            const response = await fetch(`/api/v1/tags/${paddedRoomNumber}/occupy`, {
                method: 'GET',
                headers: {
                    'Cache-Control': 'no-cache, no-store, must-revalidate',
                    'Pragma': 'no-cache',
                    'Expires': '0'
                }
            });
            if (response.ok) {
                const data = await response.json();
                setOccupyId(data.id);
                setCreatedAt(data.created_at);
                setRegistrantName(data.registrant_name);
                setRegistrantNumber(data.registrant_number);
            } else {
                resetOccupyData();
            }
        } catch (error) {
            console.error("Error fetching occupy data:", error);
            resetOccupyData();
        }
    };

    const resetOccupyData = () => {
        setOccupyId(null);
        setCreatedAt("");
        setRegistrantName("");
        setRegistrantNumber("");
        setRotation(0);
    };

    const handleQueryChange = (e) => {
        setRegistrantQuery(e.target.value);
    };

    // 検索ボタンまたはEnterキーが押されたときの処理
    const handleSearch = async () => {
        const isNumber = /^\d{6}$/.test(registrantQuery);
        const searchQuery = isNumber
            ? registrantQuery
            : registrantQuery.replace(/[-\s０-９]/g, (char) => String.fromCharCode(char.charCodeAt(0) - 65248)).replace(/[-\s]/g, "");

        const endpoint = isNumber
            ? `/api/v1/registrants/${searchQuery}`
            : `/api/v1/registrants/phone/${searchQuery}`;

        try {
            const response = await fetch(endpoint);
            if (response.ok) {
                const data = await response.json();
                setRegistrantName(data.name || "該当する登録者が見つかりません");
                setRegistrantNumber(data.number || "該当する番号が見つかりません");
            } else {
                setRegistrantName("該当する登録者が見つかりません");
                setRegistrantNumber("該当する番号が見つかりません");
            }
        } catch (error) {
            setRegistrantName("エラーが発生しました");
            setRegistrantNumber("");
        }
    };

    const handleKeyPress = (e) => {
        if (e.key === "Enter") {
            handleSearch();
        }
    };

    const handleStartOccupy = async () => {
        try {
            const paddedRegistrantNumber = String(registrantNumber).padStart(6, '0');
            const paddedRoomNumber = String(roomNumber).padStart(6, '0');
            const response = await fetch('/api/v1/occupies', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    occupy: {
                        registrant_id: paddedRegistrantNumber,
                        tag_id: paddedRoomNumber,
                        time_length: 0,
                        returned_at: null
                    }
                })
            });

            if (response.ok) {
                const data = await response.json();
                setOccupyId(data.id);
                setCreatedAt(data.created_at);
                setStatusChanged(true);
                alert("貸し出しが開始されました");
                await fetchOccupyData();
            } else {
                const errorData = await response.json();
                alert(`貸し出しの開始に失敗しました: ${errorData.errors ? errorData.errors.join(', ') : 'エラー内容が取得できませんでした'}`);
            }
        } catch (error) {
            console.error("Error starting occupy:", error);
            alert("エラーが発生しました");
        }
    };

    const handleEndOccupy = async () => {
        if (!occupyId) {
            alert("アクティブな占有を終了する対象がありません。");
            return;
        }

        try {
            const response = await fetch(`/api/v1/occupies/${occupyId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Cache-Control': 'no-cache'
                },
                body: JSON.stringify({
                    occupy: { returned_at: new Date().toISOString() }
                })
            });

            if (response.ok) {
                resetOccupyData();
                setStatusChanged(true);
                await fetchOccupyData();
                alert("占有を正常に終了しました");
            } else {
                alert("占有の終了に失敗しました");
            }
        } catch (error) {
            console.error("Error ending occupancy:", error);
            alert("占有の終了中にエラーが発生しました。");
        }
    };

    const handleClose = () => {
        if (statusChanged && onStatusChange) {
            onStatusChange();
        }
        onClose();
    };

    return (
        <div className="modal-overlay" onClick={handleClose}>
            <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                <button className="modal-close" onClick={handleClose}>
                    &times;
                </button>
                <div className="modal-header">
                    <h3>Room {roomNumber}</h3>
                </div>
                <div className="modal-contents">
                    <div className="search-box">
                        <input
                            type="text"
                            placeholder="会員番号または電話番号を入力..."
                            value={registrantQuery}
                            onChange={handleQueryChange}
                            onKeyDown={handleKeyPress}
                        />
                        <button onClick={handleSearch}>search</button>
                    </div>
                    <section className="content-section">
                        <section className="left-section">
                            <p>{registrantName || "Registrant.Name"}</p>
                            <p>{registrantNumber || "Registrant.Number"}</p>
                        </section>
                        <section className="right-section">
                            <p>Arrived_at: {createdAt ? new Date(createdAt).toLocaleString("ja-JP", { month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", hour12: false }) : "N/A"}</p>
                            <div className="clock">
                                <svg viewBox="0 0 100 100" className="clock-svg">
                                    <circle cx="50" cy="50" r="45" className="clock-face" />
                                    <line
                                        x1="50" y1="50"
                                        x2={50 + 40 * Math.cos(Math.PI / 180 * (rotation - 90))}
                                        y2={50 + 40 * Math.sin(Math.PI / 180 * (rotation - 90))}
                                        className="clock-hand"
                                    />
                                </svg>
                            </div>
                        </section>
                    </section>
                </div>
                <div className="action-buttons">
                    <button onClick={handleStartOccupy} disabled={occupyId !== null || !registrantName}>
                        Start
                    </button>
                    <button onClick={handleEndOccupy} disabled={occupyId === null}>
                        End
                    </button>
                </div>
            </div>
        </div>
    );
};

export default RoomModal;
