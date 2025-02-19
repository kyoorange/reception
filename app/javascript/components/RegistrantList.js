import React from 'react';

function RegistrantList({ registrants }) {
    return (
        <div className="registrant-list">
            {registrants && registrants.length > 0 ? (
                registrants.map((registrant, index) => (
                    <div key={index} className="registrant-card">
                        <div>名前: {registrant.name}</div>
                        <div>
                            <a href={`mailto:${registrant.email}`}>{registrant.email}</a>
                        </div>
                    </div>
                ))
            ) : (
                <p>候補者が見つかりませんでした。</p>
            )}
        </div>
    );
}

export default RegistrantList;
